//
//  ContactsFlowUI.swift
//  ContactsFlowUI
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import Combine
import CombineEx
import SwiftUI
import SwiftUIEx
import ReducerArchitecture

private func delayedActionPublisher(_ f: @escaping (Contact) -> Void) -> (Contact) -> AnySingleValuePublisher<Void, Never> {
    return {
        f($0)
        return Just(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseType()
    }
}

private let contactActionEnv: ContactAction.StoreEnvironment = .init(
    saveContact: delayedActionPublisher(Contact.save),
    deleteContact: delayedActionPublisher(Contact.delete)
)

struct ContactsFlowView: View {
    func pickAction() -> StoreUI<ActionPicker>  {
        .init(ActionPicker.store())
    }

    func makeContact() -> StoreUI<ContactForm> {
        .init(ContactForm.store(contact: nil))
    }

    func saveContact(_ contact: Contact) -> StoreUI<ContactAction> {
        .init(ContactAction.store(contact: contact, action: .save, env: contactActionEnv))
    }

    func findContact() -> StoreUI<FindContact> {
        let store = FindContact.store(
            env: .init(
                findContacts: { text in
                    Just(Contact.find(prefix: text)).eraseType()
                }
            )
        )
        return .init(store)
    }

    func contactDetails(_ contact: Contact) -> StoreUI<ContactDetails> {
        .init(ContactDetails.store(contact))
    }

    func editContact(_ contact: Contact?) -> StoreUI<ContactForm> {
        .init(ContactForm.store(contact: contact))
    }

    func deleteContact(_ contact: Contact) -> StoreUI<ContactAction> {
        .init(ContactAction.store(contact: contact, action: .delete, env: contactActionEnv))
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
