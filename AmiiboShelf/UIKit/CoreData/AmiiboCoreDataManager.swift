//
//  CoreDataManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import Core
import CoreData
import UIKit
import UserNotifications

@available(*, deprecated, message: "Please use SwiftDataManager instead")
class AmiiboCoreDataManager {
    // MARK: Singleton
    static let current = AmiiboCoreDataManager(containerName: "AmiiboShelf")

    // MARK: Variables
    var dataDelegate: AmiiboDataDelegate?
    var dataManager: CoreDataManager

    // MARK: Initializers
    public init(dataDelegate: AmiiboDataDelegate? = nil, containerName: String) {
        self.dataDelegate = dataDelegate
        self.dataManager = .init(container: .load(name: containerName)!)
    }

    // MARK: Methods
    func fetch(predicate: String?, arg: String) -> [CDAmiibo] {
        guard let predicate else { return dataManager.fetch() }

        return dataManager.fetch(predicate: NSPredicate(format: predicate, arg))
    }

    @discardableResult
    func saveContext() -> Bool {
        do {
            try dataManager.save()
            return true
        } catch {
            return false
        }
    }
}
