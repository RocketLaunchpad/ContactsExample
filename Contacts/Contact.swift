//
//  Contact.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/7/21.
//

import Foundation
import FoundationEx

struct Contact: Hashable {
    @UserDefaultsBacked(key: "contacts", defaultValue: [])
    static var all: [Contact]

    let firstName: String
    let lastName: String
    let phone: String

    var fullName: String {
        "\(firstName) \(lastName)"        
    }

    init?(firstName: String, lastName: String, phone: String) {
        guard !firstName.isEmpty else { return nil }
        guard !lastName.isEmpty else { return nil }
        guard !phone.isEmpty else { return nil }

        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }

    static func find(prefix: String) -> [Contact] {
        all.filter { $0.firstName.hasPrefix(prefix) || $0.lastName.hasPrefix(prefix) }
    }

    static func save(_ contact: Contact) {
        print("saving contact: \(contact.fullName)")
        if let index = all.firstIndex(where: { $0.id == contact.id }) {
            all[index] = contact
        }
        else {
            all.append(contact)
        }
    }

    static func delete(_ contact: Contact) {
        print("deleting contact: \(contact.fullName)")
        guard let index = all.firstIndex(where: { $0.id == contact.id }) else {
            assertionFailure()
            return
        }
        all.remove(at: index)
    }
}

extension Contact: Identifiable {
    var id: String {
        "\(firstName) \(lastName)"
    }
}

extension Contact: PropertyListRepresentable {
    private static let firstName = "firstName"
    private static let lastName = "lastName"
    private static let phone = "phone"

    func encode() -> PropertyListDict {
        var dict: PropertyListDict = [:]
        dict.set(firstName, forKey: Self.firstName)
        dict.set(lastName, forKey: Self.lastName)
        dict.set(phone, forKey: Self.phone)
        return dict
    }

    static func decode(_ dict: PropertyListDict) throws -> Self {
        try .init(dict)
    }

    init(_ dict: PropertyListDict) throws {
        do {
            firstName = try dict.get(Self.firstName)
            lastName = try dict.get(Self.lastName)
            phone = try dict.get(Self.phone)
        }
        catch {
            throw PropertyListError<Self>.decode(error)
        }
    }
}
