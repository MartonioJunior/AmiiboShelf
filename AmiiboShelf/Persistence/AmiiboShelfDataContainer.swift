//
//  AmiiboShelfDataContainer.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 22/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//
import SwiftData

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Amiibo.self)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
