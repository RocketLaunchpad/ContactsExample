//
//  ActionPickerUI.swift
//  Contacts
//
//  Created by Ilya Belenkiy on 3/6/21.
//

import SwiftUI

struct ActionPickerView: View {
    @ObservedObject var store: ActionPicker.Store
    let canGoBack: Bool

    var body: some View {
        VStack(spacing: 30) {
            Button("Find Contact") {
                store.publish(.findContact)
            }
            Button("Add Contact") {
                store.publish(.addContact)
            }
        }
        .navigationBarBackButtonHidden(!canGoBack)
        .navigationBarHidden(true)
    }
}

extension ActionPicker.Store: NavigationItemContent {
    func makeView() -> some View {
        ActionPickerView(store: self, canGoBack: false)
    }
}

struct ActionPickerUI_Previews: PreviewProvider {
    static var previews: some View {
        ActionPickerView(store: ActionPicker.store(), canGoBack: false)
            .previewDevice("iPhone 12 Pro")
    }
}
