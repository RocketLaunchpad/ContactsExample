//
//  ContactAction.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/7/21.
//

import Foundation
import CombineEx
import ReducerArchitecture

enum ContactAction: StoreNamespace {
    enum Action {
        case save
        case delete
    }

    typealias PublishedValue = Void

    struct StoreEnvironment {
        var saveContact: (Contact) -> AnySingleValuePublisher<Void, Never>
        var deleteContact: (Contact) -> AnySingleValuePublisher<Void, Never>
    }

    enum MutatingAction {
        case markDone
    }

    enum EffectAction {
        case perform
    }

    struct StoreState {
        let contact: Contact
        let action: Action
        var done = false
        var progressMessage: String

        init(contact: Contact, action: Action) {
            self.contact = contact
            self.action = action
            switch action {
            case .save:
                progressMessage = "Saving..."
            case .delete:
                progressMessage = "Deleting..."
            }
        }
    }
}

extension ContactAction {
    static func store(contact: Contact, action: Action, env: StoreEnvironment) -> Store {
        let store = Store(identifier, .init(contact: contact, action: action), reducer: reducer)
        store.environment = env
        return store
    }

    static let reducer = Reducer(
        run: { state, action in
            switch action {
            case .markDone:
                state.done = true
                state.progressMessage = "Done!"
            }
            return nil
        },
        effect: { env, state, action in
            guard let env = env else {
                assertionFailure()
                return Reducer.effect(.noAction)
            }

            switch action {
            case .perform:
                let envAction: (Contact) -> AnySingleValuePublisher<Void, Never>
                switch state.action {
                case .save:
                    envAction = env.saveContact
                case .delete:
                    envAction = env.deleteContact
                }

                return envAction(state.contact)
                    .map { _ in .mutating(.markDone) }
                    .eraseToAnyPublisher()
            }
        }
    )
}

