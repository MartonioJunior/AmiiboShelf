//
//  DateFormatter+Validation.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 04/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

extension DateFormatter {
    func validate(releaseDate date: Date?, default noDateMessage: String = "Not Available") -> String {
        guard let releaseDate = date else { return noDateMessage }

        return self.string(from: releaseDate)
    }
}
