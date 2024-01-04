//
//  AmiiboAPI.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 17/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import Core
import Combine
import UIKit
import UserNotifications

struct AmiiboAPI {
    // MARK: Constants
    static let current = AmiiboAPI()
    static let defaultImage = #imageLiteral(resourceName: "Amiibo-No-Image.png")
    let localStorage: FileManager

    // MARK: Variables
    var apiService: APIClient

    // MARK: Initializers
    init(
        fileManager: FileManager = .default,
        service: APIClient = .init(host: "www.amiiboapi.com", api: "/api/")
    ) {
        apiService = service
        localStorage = fileManager
    }
}

// MARK: Combine
extension AmiiboAPI {
    var amiiboPublisher: AnyPublisher<[AmiiboAPI.Model], Error> {
        apiService.publisher(for: .amiiboList).compactMap { $0.amiibo }.eraseToAnyPublisher()
    }

    func getAmiiboList() async throws -> [AmiiboAPI.Model] {
        for try await item in amiiboPublisher.values {
            return item
        }

        return []
    }
}
