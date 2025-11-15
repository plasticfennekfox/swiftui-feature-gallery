//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Fuchs on 1/11/25.
//

import SwiftUI
import SwiftData
import AppCore
import FeatureSwiftData

@main
struct ExampleAppApp: App {
    private let container = AppContainer.default

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
                .modelContainer(for: [SwiftNote.self])
        }
    }
}
