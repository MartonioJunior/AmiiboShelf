//
//  AmiiboImageManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import Core

extension AmiiboAPI {
    // MARK: Static Methods
    func baseDirectory() throws -> URL { try localStorage.documentDirectory() }

    func delete(imageFor amiibo: Amiibo) throws {
        guard let url = localImageURL(for: amiibo.id),
              localStorage.fileExists(at: url) == true else { return }

        try localStorage.removeItem(at: url)
    }

    func download(imageFor amiibo: AmiiboAPI.Model, using session: URLSession = .shared) async throws {
        let amiiboID = amiibo.getID()

        guard let imageURL = URL(string: amiibo.image),
              let imageFileURL = localImageURL(for: amiiboID) else { return }

        try? await session.download(dataFrom: imageURL, into: imageFileURL, modifier: convertImage)
    }

    func fileExists(for amiiboID: String) -> Bool? {
        do {
            return localStorage.fileExists(at: try baseDirectory() + localImageEndpoint(for: amiiboID))
        } catch {
            return nil
        }
    }

    func localImageEndpoint(for amiiboID: String) -> LocalEndpoint {
        Endpoint("amiibos/\(amiiboID).png")
    }

    func localImageURL(for amiiboID: String) -> URL? {
        do {
            let appDirectory = try baseDirectory()
            try localStorage.require(directoryAt: appDirectory + LocalEndpoint("amiibos"))
            return appDirectory + localImageEndpoint(for: amiiboID)
        } catch {
            return nil
        }
    }

    func getImage<K, R>(from path: Endpoint<K, R>) -> UIImage {
        guard let url = try? baseDirectory().appending(path),
              let image = UIImage(contentsOfFile: url.path) else {
            return AmiiboAPI.defaultImage
        }

        return image
    }

    func convertImage(_ data: Data) -> Data {
        UIImage(data: data)?.pngData() ?? .init()
    }
}
