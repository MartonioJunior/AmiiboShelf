//
//  AmiiboDisplayProtocol.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 19/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Not used by SwiftUI")
protocol AmiiboDisplayProtocol {
    var amiibo: Amiibo? { get set }
    var frame: CGRect { get }
}
