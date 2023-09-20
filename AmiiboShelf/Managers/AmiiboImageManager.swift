//
//  AmiiboImageManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class AmiiboImageManager {
    // MARK: Static Variables
    static var dataDelegate: AmiiboDataDelegate?

    // MARK: Static Methods
    static func downloadImage(from apiModel: AmiiboAPIModel) {
        guard let imageUrl = URL(string: apiModel.image) else { return }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            let amiiboID = apiModel.getID()
            guard let imageData = data, error == nil, let imageURL = AmiiboImageManager.fileURL(for: amiiboID) else { return }

            AmiiboImageManager.saveImage(data: imageData, onURL: imageURL)
            dataDelegate?.imageDownloaded(for: amiiboID)
        }

        DispatchQueue.global().async {
            task.resume()
        }
    }
    
    static func saveImage(data: Data, onURL url: URL) {
        if let image = UIImage(data: data) {
            try? image.pngData()?.write(to: url)
        }
    }
    
    static func reloadImages(from array: inout [Amiibo]) {
        for index in 0..<array.count {
            AmiiboImageManager.reloadImage(from: &array[index])
        }
    }
    
    static func reloadImage(from amiibo: inout Amiibo) {
        amiibo.image = AmiiboImageManager.getImage(path: amiibo.imagePath)
    }
    
    static func getImage(path: String?) -> UIImage {
        guard var url = directoryURL(), let path = path else { return #imageLiteral(resourceName: "Amiibo-No-Image.png") }
        url.appendPathComponent(path)
        return UIImage(contentsOfFile: url.path) ?? #imageLiteral(resourceName: "Amiibo-No-Image.png")
    }
    
    // TODO: Implement the method
    static func deleteImage(for amiibo: Amiibo) {
        
    }
    
    static func baseDirectory() throws -> URL {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    static func checkFile(atPath path: String) -> Bool? {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func fileExists(for amiiboID: String) -> Bool? {
        guard let path = self.filePath(for: amiiboID) else { return nil }

        do {
            var appDirectory = try baseDirectory()
            appDirectory.appendPathComponent(path)
            return checkFile(atPath: path)
        } catch {
            return nil
        }
    }
    
    static func directoryURL() -> URL? {
        return try? baseDirectory()
    }
    
    static func fileURL(for amiiboID: String) -> URL?  {
        do {
            var appDirectory = try baseDirectory()
            appDirectory = appDirectory.appendingPathComponent("amiibos")
            if let fileExists = checkFile(atPath: appDirectory.path), !fileExists {
                try FileManager.default.createDirectory(atPath: appDirectory.path, withIntermediateDirectories: true, attributes: nil)
            }
            appDirectory = appDirectory.appendingPathComponent(amiiboID+".png")
            return appDirectory
        } catch {
            return nil
        }
    }
    
    static func filePath(for amiiboID: String) -> String? {
        return "amiibos/"+amiiboID+".png"
    }
}
