//
//  ActionPicker.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Foundation
import ReducerArchitecture

enum ActionPicker: StoreNamespace {
    enum Value: Hashable {
        case findContact
        case addContact
    }

    typealias StoreEnvironment = Never
    typealias MutatingAction = Never
    typealias EffectAction = Never
    typealias PublishedValue = Value

    struct StoreState {
    }
}

extension ActionPicker {
    static func store() -> Store {
        Store(identifier, .init(), reducer: reducer)
    }

    static let reducer = Reducer { _, _ in nil }
}

