//
//  AmiiboShelfPreviewContainer.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 22/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//
#if targetEnvironment(simulator)
import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let inMemorySettings = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Amiibo.self, configurations: inMemorySettings)

        let amiibos = [
            Amiibo(id: "Joe", name: "Mario", type: "Card",
                   amiiboSeries: "Mario Sluggers", gameSeries: "Super Mario", addToShelf: false),
            Amiibo(id: "Mack", name: "Peach", type: "Card",
                   amiiboSeries: "Mario Sluggers", gameSeries: "Super Mario", addToShelf: true),
            Amiibo(id: "Steve", name: "Isabelle", type: "Card",
                   amiiboSeries: "Animal Crossing", gameSeries: "Animal Crossing", addToShelf: false),
            Amiibo(id: "Louie", name: "Mario 35th Statue", type: "Figure",
                   amiiboSeries: "Mario 35th Anniversary", gameSeries: "Super Mario", addToShelf: false),
            Amiibo(id: "Jack", name: "Link", type: "Figure",
                   amiiboSeries: "Smash", gameSeries: "The Legend of Zelda", addToShelf: true)
        ]

        amiibos.forEach(container.mainContext.insert)

        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

extension Amiibo {
    @MainActor static var debugValue: Amiibo {
        let descriptor = FetchDescriptor<Amiibo>()
        return (try? previewContainer.mainContext.fetch(descriptor).first)
                ?? Amiibo(id: "", name: "", type: "", addToShelf: false)
    }
}
#endif
