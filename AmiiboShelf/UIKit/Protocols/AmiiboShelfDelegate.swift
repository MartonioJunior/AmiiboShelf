//
//  AmiiboShelfDelegate.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Please use SwiftData instead")
protocol AmiiboShelfDelegate: AnyObject {
    func shelf(added amiibo: Amiibo)
    func shelf(removed amiibo: Amiibo)
}
