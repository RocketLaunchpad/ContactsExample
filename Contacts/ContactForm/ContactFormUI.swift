//
//  ContactFormUI.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import SwiftUI

struct ContactFormView: View {
    @ObservedObject var store: ContactForm.Store

    var body: some View {
        VStack {
            VStack {
                if store.state.isNew {
                    Divider()
                    TextField(
                        "First Name",
                        text: store.binding(\.firstName, { .updateFirstName($0) })
                    )
                    Divider()
                    TextField(
                        "Last Name",
                        text: store.binding(\.lastName, { .updateLastName($0) })
                    )
                }
                else {
                    Text(store.state.contactFullName).padding()
                }
                Divider()
                TextField(
                    "Phone",
                    text: store.binding(\.phone, { .updatePhone($0) })
                )
                Divider()
            }
            .padding(EdgeInsets(top: 50, leading: 25, bottom: 40, trailing: 25))
            Button("Save") {
                guard let contact = store.state.contact else { return assertionFailure() }
                self.store.publish(contact)
            }
            .disabled(!store.state.isValid)
            Spacer()
        }
        .navigationTitle("Contact Details Form")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ContactForm.Store: NavigationItemContent {
    func makeView() -> some View {
        ContactFormView(store: self)
    }
}

struct ContactFormUI_Previews: PreviewProvider {
    static let testContact = Contact(firstName: "John", lastName: "Appleseed", phone: "123-45-6789")!

    static var previews: some View {
        Group {
            NavigationView {
                ContactFormView(store: ContactForm.store(contact: nil))
            }
            .previewDevice("iPhone 12 Pro")

            NavigationView {
                ContactFormView(store: ContactForm.store(contact: testContact))
            }
            .previewDevice("iPhone 12 Pro")
        }
    }
}
