//
//  AppFlow.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/7/21.
//

import SwiftUI
import Combine
import CombineEx

enum AppFlow {
    typealias FinshedActionPublisher = AnySingleValuePublisher<Void, Never>
    typealias CancellableFinshedActionPublisher = AnySingleValuePublisher<Void, Cancel>
    static let finishedAction: FinshedActionPublisher = Just(()).eraseType()
    static let cancellableFinishedAction: CancellableFinshedActionPublisher = Just(()).addUserCanCancel().eraseType()
    static let noAction = Just(()).eraseType()
    static let cancellableNoAction = Just(()).addUserCanCancel().eraseType()

    static func start() -> Just<Void> {
        Just(())
    }
}

extension Publisher where Failure == Never {
    func addUserCanCancel() -> Publishers.MapError<Self, Cancel> {
        addErrorType(Cancel.self)
    }
}

extension Publisher where Output == Void, Failure == Cancel {
    func catchCancelAsVoid() -> Publishers.ReplaceError<Self> {
        replaceError(with: ())
    }
}
