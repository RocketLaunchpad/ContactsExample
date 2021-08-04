//
//  ContactDetails.swift
//  ContactDetails
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import ReducerArchitecture

enum ContactDetails : Namespace {
    enum Action: Hashable {
        case edit(Contact)
        case delete(Contact)
    }

    class Store: StateStore<Never, State, Never, Never, Action> {}
    typealias Reducer = Store.Reducer

    struct State {
        let contact: Contact
    }
}

extension ContactDetails {
    static func store(_ contact: Contact) -> Store {
        Store(identifier, .init(contact: contact), reducer: reducer)
    }

    static let reducer = Reducer { _, _ in nil }
}
