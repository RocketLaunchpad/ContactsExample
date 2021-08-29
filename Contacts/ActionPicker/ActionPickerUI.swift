//
//  ActionPickerUI.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import SwiftUI
import SwiftUIEx
import ReducerArchitecture

extension ActionPicker: StoreUIWrapper {
    struct ContentView: StoreContentView {
        typealias StoreWrapper = ActionPicker
        @ObservedObject var store: ActionPicker.Store

        var body: some View {
            VStack(spacing: 30) {
                Button("Find Contact") {
                    store.publish(.findContact)
                }
                Button("Add Contact") {
                    store.publish(.addContact)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct ActionPickerUI_Previews: PreviewProvider {
    static var previews: some View {
        ActionPicker.ContentView(store: ActionPicker.store())
            .previewDevice("iPhone 12 Pro")
    }
}
