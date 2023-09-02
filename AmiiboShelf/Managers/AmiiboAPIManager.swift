//
//  AmiiboAPIManager.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 17/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import UserNotifications

class AmiiboAPIManager {
    // MARK: Constants
    static let current = AmiiboAPIManager()
    let apiPath = "https://www.amiiboapi.com/api/"
    
    func getDataFromAPI(query: String, finishedWith: @escaping ([AmiiboAPIModel]) -> Void) {
        guard let queryUrl = URL(string: apiPath+query) else {
            //print("Unable to create URL")
            return
        }
        self.notify(message: "Looking for new amiibo... Please wait...", identifier: "fetchAPI", thread: "updatingData")
        let task = URLSession.shared.dataTask(with: queryUrl) { data,response,error in
            guard let apiData = data, error == nil else {
                //print(error)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AmiiboAPIStruct.self, from: apiData)
                finishedWith(result.amiibo)
            } catch {
                //print(error)
            }
        }
        
        DispatchQueue.global().async {
            task.resume()
        }
    }
    
    func notify(message: String, identifier: String, thread: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Amiibo Shelf"
        notificationContent.body = message
        notificationContent.threadIdentifier = thread
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //print(error)
            return
        }
    }
}

struct AmiiboAPIStruct: Codable {
    var amiibo: [AmiiboAPIModel]
}
