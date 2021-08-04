//
//  ContactsFlowUI.swift
//  ContactsFlowUI
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import Combine
import CombineEx
import SwiftUI

private func delayedActionPublisher(_ f: @escaping (Contact) -> Void) -> (Contact) -> AnySingleValuePublisher<Void, Never> {
    return {
        f($0)
        return Just(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseType()
    }
}

private let contactActionEnv: ContactAction.Environment = .init(
    saveContact: delayedActionPublisher(Contact.save),
    deleteContact: delayedActionPublisher(Contact.delete)
)

struct ContactsFlowView: View {
    func pickAction() -> ActionPicker.Store {
        ActionPicker.store()
    }

    func makeContact() -> ContactForm.Store {
        ContactForm.store(contact: nil)
    }

    func saveContact(_ contact: Contact) -> ContactAction.Store {
        ContactAction.store(contact: contact, action: .save, env: contactActionEnv)
    }

    func findContact() -> FindContact.Store {
        FindContact.store(
            env: .init(
                findContacts: { text in
                    Just(Contact.find(prefix: text)).eraseType()
                }
            )
        )
    }

    func contactDetails(_ contact: Contact) -> ContactDetails.Store {
        ContactDetails.store(contact)
    }

    func editContact(_ contact: Contact?) -> ContactForm.Store {
        ContactForm.store(contact: contact)
    }

    func deleteContact(_ contact: Contact) -> ContactAction.Store {
        ContactAction.store(contact: contact, action: .delete, env: contactActionEnv)
    }

    var body: some View {
        NavigationView {
            pickAction().then { action, rootItem in
                switch action {
                case .addContact:
                    makeContact().then { contact, _ in
                        saveContact(contact).thenPop(to: rootItem)
                    }
                case .findContact:
                    findContact().then { contact, _ in
                        contactDetails(contact).then { action, _ in
                            switch action {
                            case .edit(let contact):
                                editContact(contact).then { contact, _ in
                                    saveContact(contact).thenPop(to: rootItem)
                                }
                            case .delete(let contact):
                                deleteContact(contact).thenPop(to: rootItem)
                            }
                        }
                    }
                }
            }
        }
    }
}
