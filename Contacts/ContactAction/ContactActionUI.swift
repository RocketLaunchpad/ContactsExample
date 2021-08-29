//
//  ContactActionUI.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/7/21.
//

import Combine
import CombineEx
import SwiftUI
import SwiftUIEx
import ReducerArchitecture

extension ContactAction: StoreUIWrapper {
    struct ContentView: StoreContentView {
        typealias StoreWrapper = ContactAction
        @ObservedObject var store: ContactAction.Store

        var body: some View {
            VStack(spacing: 25) {
                Text(store.state.progressMessage)
                Button("Start Over") {
                    store.publish(())
                }
                .disabled(!store.state.done)
            }
            .onAppear {
                store.send(.effect(.perform))
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContactActionUI_Previews: PreviewProvider {
    static let testContact = Contact(firstName: "John", lastName: "Appleseed", phone: "123-45-6789")!

    static func testStore() -> ContactAction.Store {
        let store = ContactAction.store(
            contact: Self.testContact,
            action: .save,
            env: .init(
                saveContact: { _ in
                    Just(())
                        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                        .eraseType()
                },
                deleteContact: { _ in Just(()).eraseType() }
            )
        )
        return store
    }

    static var previews: some View {
        ContactAction.ContentView(store: testStore())
            .previewDevice("iPhone 12 Pro")
    }
}
