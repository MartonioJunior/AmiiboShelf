//
//  AmiiboDisplayProtocol.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 19/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

protocol AmiiboDisplayProtocol {
    var amiibo: Amiibo? { get set }
    var sourceRect: CGRect { get }
}
