//
//  SwiftDataManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 22/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Core
import Foundation
import SwiftData

extension SwiftDataManager {
    @MainActor func fetchAmiibo(from id: String) -> [Amiibo] {
        fetch(Amiibo.self, filteredBy: #Predicate<Amiibo> { $0.id == id })
    }

    @MainActor func insert(new data: AmiiboAPI.Model) async {
        let newAmiibo = Amiibo(from: data)
        await updateImage(for: newAmiibo, with: data)
        insert(newAmiibo)
    }

    #warning("Refactor the method and move whatever possible to AmiiboAPI")
    func sync(with api: AmiiboAPI = .current) async {
        guard let apiAmiibos = try? await api.getAmiiboList() else { return }

        for amiibo in apiAmiibos {
            if let oldAmiibo = await fetchAmiibo(from: amiibo.getID()).first {
                await update(oldAmiibo, with: amiibo)
            } else {
                await insert(new: amiibo)
            }
        }

        try? await AmiiboShelfApp.notify(message: "Amiibo data up to date!",
                                         identifier: "apiFetch",
                                         thread: "apiFetch")
    }

    @MainActor func update(_ amiibo: Amiibo, with newData: AmiiboAPI.Model) async {
        amiibo.update(with: newData)
        await updateImage(for: amiibo, with: newData)
    }

    #warning("Refactor the method and move whatever possible to AmiiboAPI")
    @MainActor func updateImage(
        for amiibo: Amiibo,
        with newData: AmiiboAPI.Model,
        using api: AmiiboAPI = .current
    ) async {
        guard api.fileExists(for: amiibo.id) == false else { return }

        try? await api.download(imageFor: newData)

        guard amiibo.imagePath == nil, let amiiboURL = api.localImageURL(for: amiibo.id) else { return }

        amiibo.set(imageURL: amiiboURL)
    }
}
