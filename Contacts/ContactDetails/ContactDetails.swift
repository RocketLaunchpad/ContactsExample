//
//  ContactDetails.swift
//  ContactDetails
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import ReducerArchitecture

enum ContactDetails: StoreNamespace {
    enum Action: Hashable {
        case edit(Contact)
        case delete(Contact)
    }

    typealias StoreEnvironment = Never
    typealias MutatingAction = Never
    typealias EffectAction = Never
    typealias PublishedValue = Action

    struct StoreState {
        let contact: Contact
    }
}

extension ContactDetails {
    static func store(_ contact: Contact) -> Store {
        Store(identifier, .init(contact: contact), reducer: reducer)
    }

    static let reducer = Reducer { _, _ in nil }
}
