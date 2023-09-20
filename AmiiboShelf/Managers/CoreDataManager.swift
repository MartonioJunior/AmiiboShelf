//
//  CoreDataManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class CoreDataManager {
    // MARK: Singleton
    static let current = CoreDataManager()

    // MARK: Variables
    var dataDelegate: AmiiboDataDelegate?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AmiiboShelf")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    @discardableResult
    func saveContext() -> Bool {
        let context = persistentContainer.viewContext
        var saved = false
        if context.hasChanges {
            do {
                try context.save()
                saved = true
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                saved = false
            }
        } else {
            saved = true
        }
        return saved
    }

    // MARK: Methods
    func fetch(predicate: String?, arg: String) -> [CDAmiibo] {
        let request = NSFetchRequest<CDAmiibo>(entityName: "CDAmiibo")
        if let format = predicate {
            request.predicate = NSPredicate(format: format, arg)
        }

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print(error)
            return []
        }
    }
    
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
        guard let cdAmiibo = self.getAmiibo(from: amiibo.id) else {
            return false
        }
        cdAmiibo.onShelf = onShelf
        return self.saveContext()
    }
    
    func updateCoreData() {
        AmiiboAPIManager.current.getDataFromAPI(query: "amiibo", finishedWith: { apiData in
            let amiiboCoreData = CoreDataManager.current.fetchAllAmiibo()
            for amiibo in apiData {
                if let existingAmiibo = amiiboCoreData.first(where: { existingAmiibo in
                    return existingAmiibo.amiiboID == amiibo.head+amiibo.tail
                }) {
                    self.update(existingAmiibo, with: amiibo)
                } else {
                    self.insert(new: amiibo)
                }
            }
        })
        AmiiboAPIManager.current.notify(message: "Amiibo data up to date!", identifier: "apiFetch", thread: "apiFetch")
        dataDelegate?.amiiboDataUpdated()
    }
    
    func insert(new amiibo: AmiiboAPIModel) {
        let newCDAmiibo = CDAmiibo(context: persistentContainer.viewContext)
        newCDAmiibo.onShelf = false
        update(newCDAmiibo, with: amiibo)
        dataDelegate?.new(amiibo: Amiibo(with: newCDAmiibo))
    }
    
    func update(_ amiibo: CDAmiibo, with newAmiibo: AmiiboAPIModel) {
        let amiiboID = newAmiibo.head+newAmiibo.tail
        amiibo.amiiboID = amiiboID
        amiibo.amiiboSeries = newAmiibo.amiiboSeries
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        amiibo.auReleaseDate = formatter.date(from: newAmiibo.release?.au ?? "")
        amiibo.characterName = newAmiibo.name
        amiibo.euReleaseDate = formatter.date(from: newAmiibo.release?.eu ?? "")
        amiibo.gameSeries = newAmiibo.gameSeries
        
        if let fileExists = AmiiboImageManager.fileExists(for: amiiboID), !fileExists {
            AmiiboImageManager.downloadImage(from: newAmiibo)
            if amiibo.imageURL == nil {
                amiibo.imageURL = AmiiboImageManager.filePath(for: amiiboID)
            }
        }
        
        amiibo.jpReleaseDate = formatter.date(from: newAmiibo.release?.jp ?? "")
        amiibo.naReleaseDate = formatter.date(from: newAmiibo.release?.na ?? "")
        amiibo.type = newAmiibo.type
        self.saveContext()
    }
    
    func remove(amiibo: CDAmiibo) {
        persistentContainer.viewContext.delete(amiibo)
    }
}
