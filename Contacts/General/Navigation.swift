//
//  Navigation.swift
//  Navigation
//
//  Created by Ilya Belenkiy on 8/1/21.
//

import Foundation
import Combine
import CombineEx
import SwiftUI

protocol NavigationItemContent: AnyObject {
    associatedtype ContentView: View
    associatedtype Value

    func makeView() -> ContentView
    var value: AnyPublisher<Value, Cancel> { get }
}

extension NavigationItemContent {
    func then<V: View>(@ViewBuilder next: @escaping (Value, AnyNavigationItem) -> V) -> NavigationItemView<Self, V> {
        NavigationItemView(self, next: next)
    }

    func endFlow(with sideEffect: (() -> Void)? = nil) -> NavigationItemView<Self, EmptyView> {
        NavigationItemView(self, sideEffect: sideEffect)
    }

    func thenPop(to item: AnyNavigationItem) -> some View {
        endFlow { item.linkIsActive = false }
    }
}

class AnyNavigationItem: ObservableObject {
    @Published var linkIsActive = false
}

class NavigationItem<Content: NavigationItemContent>: AnyNavigationItem {
    let content: Content
    private var subscriptions = Set<AnyCancellable>()

    @Published var value: Content.Value?

    init(_ content: Content, sideEffect: (() -> Void)? = nil) {
        self.content = content
        super.init()

        content.value.replaceErrorWithNil()
            .sink { [unowned self] in
                value = $0
                linkIsActive = true
                sideEffect?()
            }
            .store(in: &subscriptions)
    }
}

struct NavigationItemView<Content: NavigationItemContent, NextView: View>: View {
    @ObservedObject var navigationItem: NavigationItem<Content>
    let nextView: (Content.Value, AnyNavigationItem) -> NextView

    init(_ content: Content, @ViewBuilder next: @escaping (Content.Value, AnyNavigationItem) -> NextView) {
        self.navigationItem = NavigationItem(content)
        self.nextView = next
    }

    @ViewBuilder
    private func makeNextView() -> some View {
        if let value = navigationItem.value {
            nextView(value, navigationItem)
        }
        else {
            EmptyView()
        }
    }

    var body: some View {
        VStack {
            navigationItem.content.makeView()
            if NextView.self != EmptyView.self {
                NavigationLink(
                    destination: makeNextView(),
                    isActive: $navigationItem.linkIsActive,
                    label: { EmptyView() }
                )
            }
        }
    }
}

extension NavigationItemView where NextView == EmptyView {
    init(_ content: Content, sideEffect: (() -> Void)? = nil) {
        self.navigationItem = NavigationItem(content, sideEffect: sideEffect)
        self.nextView = { _, _ in EmptyView() }
    }
}
