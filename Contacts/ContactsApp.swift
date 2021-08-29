//
//  ContactsApp.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import SwiftUI
import SwiftUIEx
import ReducerArchitecture

extension StoreUI: NavigationItemContent {}

@main
struct ContactsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
