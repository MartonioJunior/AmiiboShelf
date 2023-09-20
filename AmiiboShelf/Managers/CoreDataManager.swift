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

// TODO: Put all methods in alphabetic order under each MARK point
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
}
