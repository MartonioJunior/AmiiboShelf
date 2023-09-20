//
//  UIImage+Utilities.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 04/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(width: Int, height: Int) -> UIImage? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        return resizedImage
    }
}
