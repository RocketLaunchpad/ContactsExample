//
//  FindContact.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Foundation
import CombineEx
import ReducerArchitecture

enum FindContact: StoreNamespace {
    typealias PublishedValue = Contact

    struct StoreEnvironment {
        var findContacts: (String) -> AnySingleValuePublisher<[Contact], Never>
     }

    enum MutatingAction {
        case updateInput(String)
        case updateMatches([Contact])
    }

    enum EffectAction {
        case findContacts
    }

    struct StoreState {
        var nameInput = ""
        var matches: [Contact] = []
    }
}

extension FindContact {
    static func store(env: StoreEnvironment) -> Store {
        let store = Store(identifier, .init(), reducer: reducer)
        store.environment = env
        return store
    }

    static let reducer = Reducer(
        run: { state, action in
            switch action {
            case .updateInput(let value):
                state.nameInput = value
                return Reducer.effect(.findContacts)

            case .updateMatches(let value):
                state.matches = value
                return nil
            }
        },
        effect: { env, state, action in
            guard let env = env else {
                assertionFailure()
                return Reducer.effect(.noAction)
            }

            switch action {
            case .findContacts:
                return env.findContacts(state.nameInput)
                    .map { .mutating(.updateMatches($0)) }
                    .eraseToAnyPublisher()
            }
        }
    )
}

