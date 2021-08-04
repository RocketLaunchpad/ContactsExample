//
//  ActionPicker.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Foundation
import ReducerArchitecture

enum ActionPicker: Namespace {
    enum Value: Hashable {
        case findContact
        case addContact
    }

    class Store: StateStore<Never, State, Never, Never, Value> {}
    typealias Reducer = Store.Reducer

    struct State {
    }
}

extension ActionPicker {
    static func store() -> Store {
        Store(identifier, .init(), reducer: reducer)
    }

    static let reducer = Reducer { _, _ in nil }
}

