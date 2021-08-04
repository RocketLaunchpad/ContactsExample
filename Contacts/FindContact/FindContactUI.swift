//
//  FindContactUI.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import Combine
import CombineEx
import SwiftUI

struct FindContactView: View {
    @ObservedObject var store: FindContact.Store

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    "First or Last Name",
                    text: store.binding(\.nameInput, { .updateInput($0) })
                )
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            Divider()
            List(store.state.matches) { contact in
                Button(action: { store.publish(contact) }) {
                    HStack {
                        Text("\(contact.firstName) \(contact.lastName)")
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Find Contact")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.mutating(.updateInput(store.state.nameInput)))
        }
    }
}

extension FindContact.Store: NavigationItemContent {
    func makeView() -> some View {
        FindContactView(store: self)
    }
}

struct FindContactUI_Previews: PreviewProvider {
    static let contacts: [Contact] = [
        Contact(firstName: "John", lastName: "Smith", phone: "123-456-7890")!,
        Contact(firstName: "Jane", lastName: "Rockwood", phone: "789-578-1345")!
    ]

    static func findContacts(prefix: String) -> AnySingleValuePublisher<[Contact], Never> {
        Just(contacts.filter { $0.firstName.hasPrefix(prefix) || $0.lastName.hasPrefix(prefix) }).eraseType()
    }

    static var previews: some View {
        NavigationView {
            FindContactView(store: FindContact.store(env: .init(findContacts: findContacts)))
        }
        .previewDevice("iPhone 12 Pro")
    }
}
