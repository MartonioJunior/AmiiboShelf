//
//  AmiiboDisplay.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: Requirements
protocol AmiiboView: View {
    var amiibo: Amiibo { get }

    init(_ amiibo: Amiibo)
}

// MARK: Default Implementation
extension AmiiboView {
    func addToShelfButton() -> Button<Text> {
        Button {
            amiibo.onShelf = !amiibo.onShelf
        } label: {
            let operationText = if amiibo.onShelf { "Remove from Shelf" } else { "Add to Shelf" }
            Text(operationText)
        }
    }

    func getBackgroundColor() -> Color {
        amiibo.onShelf ? Color(.selection) : Color(.primary)
    }

    func label(for date: Date?) -> some View {
        Text(ReleaseDateInfo.formatter.validate(releaseDate: date))
    }

    func image() -> Image { Image(uiImage: amiibo.getImage()) }

    func includePreview() -> some View {
        self.contextMenu {
            addToShelfButton()
        } preview: {
            AmiiboThumbnailView(amiibo)
        }
    }
}
