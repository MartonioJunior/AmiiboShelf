//
//  CoreDataManager+Amiibo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

extension CoreDataManager {
    // MARK: Methods
    func fetchAllAmiibo() -> [CDAmiibo] {
        return self.fetch(predicate: nil, arg: "")
    }
    
    func getAmiibo(from id: String) -> CDAmiibo? {
        return fetch(predicate: "amiiboID == %@", arg: id).first
    }
    
    func fetchAllShelfAmiibo() -> [CDAmiibo] {
        return fetch(predicate: "onShelf == %@", arg: NSNumber(booleanLiteral: true).stringValue)
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
        guard let cdAmiibo = self.getAmiibo(from: amiibo.id) else { return false }
        
        cdAmiibo.onShelf = onShelf
        return self.saveContext()
    }
    
    // MARK: Amiibo CRUD
    func insert(new amiibo: AmiiboAPIModel) {
        let newCDAmiibo = CDAmiibo(context: persistentContainer.viewContext)
        newCDAmiibo.onShelf = false
        update(newCDAmiibo, with: amiibo)
        dataDelegate?.new(amiibo: Amiibo(with: newCDAmiibo))
    }
    
    func update(_ amiibo: CDAmiibo, with newAmiibo: AmiiboAPIModel) {
        let amiiboID = newAmiibo.getID()
        amiibo.amiiboID = amiiboID
        amiibo.amiiboSeries = newAmiibo.amiiboSeries
        amiibo.characterName = newAmiibo.name
        amiibo.type = newAmiibo.type
        amiibo.gameSeries = newAmiibo.gameSeries

        if let newAmiiboRelease = newAmiibo.release {
            newAmiiboRelease.apply(to: amiibo)
        }
        
        if let fileExists = AmiiboImageManager.fileExists(for: amiiboID), !fileExists {
            AmiiboImageManager.downloadImage(from: newAmiibo)
            if amiibo.imageURL == nil {
                amiibo.imageURL = AmiiboImageManager.filePath(for: amiiboID)
            }
        }
        
        self.saveContext()
    }
    
    func remove(amiibo: CDAmiibo) {
        persistentContainer.viewContext.delete(amiibo)
    }
    
    // MARK: API
    func updateAmiibosFromAPI() {
        let api = AmiiboAPIManager.current
        api.getDataFromAPI(query: "amiibo", finishedWith: { apiData in
            let amiiboCoreData = CoreDataManager.current.fetchAllAmiibo()
            for amiibo in apiData {
                if let existingAmiibo = amiiboCoreData.first(where: { existingAmiibo in
                    return existingAmiibo.amiiboID == amiibo.getID()
                }) {
                    self.update(existingAmiibo, with: amiibo)
                } else {
                    self.insert(new: amiibo)
                }
            }
        })

        api.notify(message: "Amiibo data up to date!", identifier: "apiFetch", thread: "apiFetch")
        dataDelegate?.amiiboDataUpdated()
    }
}
