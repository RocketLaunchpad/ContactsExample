//
//  ContactForm.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Foundation
import Combine
import ReducerArchitecture

enum ContactForm: StoreNamespace {
    typealias StoreEnvironment = Never
    typealias EffectAction = Never
    typealias PublishedValue = Contact

    enum MutatingAction {
        case updateFirstName(String)
        case updateLastName(String)
        case updatePhone(String)
    }

    struct StoreState {
        var contact: Contact?
        let isNew: Bool
        var isValid: Bool

        var firstName: String
        var lastName: String
        var phone: String

        var contactFullName: String {
            contact?.fullName ?? ""
        }

        init(contact: Contact? = nil) {
            self.contact = contact
            self.isNew = (contact == nil)
            isValid = (contact != nil)

            firstName = contact?.firstName ?? ""
            lastName = contact?.lastName ?? ""
            phone = contact?.phone ?? ""
        }
    }
}

extension ContactForm {
    static func store(contact: Contact?) -> Store {
        Store(identifier, .init(contact: contact), reducer: reducer)
    }

    static let reducer = Reducer { state, action in
        switch action {
        case .updateFirstName(let value):
            guard state.isNew else {
                assertionFailure()
                return nil
            }
            state.firstName = value

        case .updateLastName(let value):
            guard state.isNew else {
                assertionFailure()
                return nil
            }
            state.lastName = value

        case .updatePhone(let value):
            state.phone = value
        }

        let updatedContact = Contact(firstName: state.firstName, lastName: state.lastName, phone: state.phone)
        if let contact = updatedContact {
            state.contact = contact
        }
        state.isValid = (updatedContact != nil)
        return nil
    }
}
