//
//  AmiiboShelfApp.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Core
import SwiftUI
import SwiftData

@main
struct AmiiboShelfApp: App {
    // MARK: Variables
    let dataManager: SwiftDataManager

    // MARK: Constructors
    init() {
        dataManager = .init(container: appContainer)
    }

    // MARK: Scene Implementation
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(appContainer)
                .task {
                    await loadData()
                }
        }
    }

    // MARK: Methods
    func loadData() async {
        await dataManager.sync(with: .current)
    }
}
