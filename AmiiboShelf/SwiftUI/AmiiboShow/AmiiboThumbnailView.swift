//
//  AmiiboThumbnailView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI

struct AmiiboThumbnailView: AmiiboView {
    // MARK: Variables
    @State internal var amiibo: Amiibo

    // MARK: Initializers
    init(_ amiibo: Amiibo) {
        self.amiibo = amiibo
    }

    // MARK: View Implementation
    var body: some View {
        image().resizable().scaledToFit()
    }
}

#Preview {
    AmiiboThumbnailView(.debugValue)
}
