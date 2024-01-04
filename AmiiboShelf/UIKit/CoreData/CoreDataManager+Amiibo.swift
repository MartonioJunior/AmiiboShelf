//
//  CoreDataManager+Amiibo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Combine
import Foundation

#warning("CoreDataManager+Amiibo extensions should be refactored")
#warning("Remove AmiiboShelf.coredata data model")
extension AmiiboCoreDataManager {
    // MARK: Methods
    func fetchAllAmiibo() -> [CDAmiibo] {
        return self.fetch(predicate: nil, arg: "")
    }

    func getAmiibo(from id: String) -> CDAmiibo? {
        return fetch(predicate: "amiiboID == %@", arg: id).first
    }

    func fetchAllShelfAmiibo() -> [CDAmiibo] {
        return fetch(predicate: "onShelf == %@", arg: NSNumber(true).stringValue)
    }

    func fetchAllFigureAmiibo() -> [CDAmiibo] {
        return fetch(predicate: "type != %@", arg: "Card")
    }

    func fetchAllCardAmiibo() -> [CDAmiibo] {
        return fetch(predicate: "type == %@", arg: "Card")
    }

    func addedToShelf(amiibo: Amiibo) -> Bool {
        return register(amiibo, onShelf: true)
    }

    func removedFromShelf(amiibo: Amiibo) -> Bool {
        return register(amiibo, onShelf: false)
    }

    func register(_ amiibo: Amiibo, onShelf: Bool) -> Bool {
        guard let cdAmiibo = getAmiibo(from: amiibo.id) else { return false }

        cdAmiibo.onShelf = onShelf
        return saveContext()
    }

    // MARK: Amiibo CRUD
    func getFigureAmiibo() -> [Amiibo] {
        return Amiibo.from(cdAmiibos: self.fetchAllFigureAmiibo())
    }

    func insert(new amiibo: AmiiboAPI.Model) {
        guard let newCDAmiibo = dataManager.insert(CDAmiibo.self, configure: {
            $0.onShelf = false
            update($0, with: amiibo)
        }) else { return }

        dataDelegate?.new(amiibo: Amiibo(with: newCDAmiibo))
    }

    func update(_ amiibo: CDAmiibo, with newAmiibo: AmiiboAPI.Model, using api: AmiiboAPI = .current) {
        let amiiboID = newAmiibo.getID()
        amiibo.amiiboID = amiiboID
        amiibo.amiiboSeries = newAmiibo.amiiboSeries
        amiibo.characterName = newAmiibo.name
        amiibo.type = newAmiibo.type
        amiibo.gameSeries = newAmiibo.gameSeries

        if let newAmiiboRelease = newAmiibo.release {
            newAmiiboRelease.apply(to: amiibo)
        }

        if let fileExists = api.fileExists(for: amiiboID), !fileExists {
//            AmiiboAPI.current.download(imageFor: newAmiibo)
            if amiibo.imageURL == nil {
                amiibo.imageURL = api.localImageURL(for: amiiboID)?.absoluteString
            }
        }

        saveContext()
    }

    func remove(amiibo: CDAmiibo) {
        dataManager.delete(amiibo)
    }

    // MARK: API
    func updateAmiibosFromAPI(
        _ tokens: inout Set<AnyCancellable>,
        using api: AmiiboAPI = .current,
        to database: AmiiboCoreDataManager = .current
    ) {
        api.amiiboPublisher.sink { _ in
//            api.notify(message: "Amiibo data up to date!", identifier: "apiFetch", thread: "apiFetch")
            self.dataDelegate?.amiiboDataUpdated()
        } receiveValue: { values in
            let amiiboCoreData = database.fetchAllAmiibo()
            for amiibo in values {
                if let existingAmiibo = amiiboCoreData.first(where: { existingAmiibo in
                    return existingAmiibo.amiiboID == amiibo.getID()
                }) {
                    self.update(existingAmiibo, with: amiibo)
                } else {
                    self.insert(new: amiibo)
                }
            }
        }.store(in: &tokens)
    }
}
