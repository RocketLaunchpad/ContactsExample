//
//  ContactDetailsUI.swift
//  ContactDetailsUI
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import SwiftUI
import SwiftUIEx
import ReducerArchitecture

extension ContactDetails: StoreUIWrapper {
    struct ContentView: StoreContentView {
        typealias StoreWrapper = ContactDetails
        @ObservedObject var store: Store

        var body: some View {
            VStack() {
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.state.contact.firstName)
                    Text(store.state.contact.lastName)
                    Text(store.state.contact.phone)
                }
                .padding(25)
                Divider()
                VStack(spacing: 20) {
                    Button("Edit Contact") {
                        store.publish(.edit(store.state.contact))
                    }
                    Button("Delete Contact") {
                        store.publish(.delete(store.state.contact))
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
            .navigationTitle("Contact Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactDetailsUI_Previews: PreviewProvider {
    static let testContact = Contact(firstName: "John", lastName: "Appleseed", phone: "123-45-6789")!

    static var previews: some View {
        NavigationView {
            ContactDetails.ContentView(store: ContactDetails.store(testContact))
        }
        .previewDevice("iPhone 12 Pro")
    }
}
