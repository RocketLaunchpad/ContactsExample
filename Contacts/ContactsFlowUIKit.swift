//
//  ContactsFlow.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Combine
import CombineEx

struct ContactsFlow {
    var pickAction: () -> AnyPublisher<ActionPicker.Value, Cancel>
    var showContactForm: (Contact?) -> AnyPublisher<Contact, Cancel>
    var findContact: () -> AnyPublisher<Contact, Cancel>
    var showContactDetails: (Contact) -> AnyPublisher<ContactDetails.Action, Cancel>
    var saveContact: (Contact) -> AnyPublisher<Void, Cancel>
    var deleteContact: (Contact) -> AnyPublisher<Void, Cancel>
    var restart: () -> AppFlow.FinshedActionPublisher

    func run() -> AnyPublisher<Void, Never> {
        AppFlow.start()
            .addUserCanCancel()
            .flatMapLatest {
                pickAction()
            }
            .flatMapLatest { action -> AnyPublisher<Void, Cancel> in
                switch action {
                case .addContact:
                    return showContactForm(nil)
                        .flatMapLatest { contact in
                            saveContact(contact)
                        }
                        .eraseToAnyPublisher()

                case .findContact:
                    return findContact()
                        .flatMapLatest { contact in
                            showContactDetails(contact)                            
                        }
                        .flatMapLatest { action -> AnyPublisher<Void, Cancel> in
                            switch action {
                            case .edit(let contact):
                                return saveContact(contact)
                            case .delete(let contact):
                                return deleteContact(contact)
                            }
                        }
                        .eraseToAnyPublisher()
                }
            }
            .catchCancelAsVoid()
            .flatMapLatest {
                restart()
            }
            .eraseToAnyPublisher()
    }
}
