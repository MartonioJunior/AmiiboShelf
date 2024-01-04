//
//  AmiiboCardView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI

struct AmiiboCardView: AmiiboView {
    // MARK: Variables
    @State private var card: Amiibo

    var amiibo: Amiibo { card }

    // MARK: Initializers
    init(_ card: Amiibo) {
        self.card = card
    }

    // MARK: View Implementation
    var body: some View {
        VStack {
            image().resizable().scaledToFit()
            Text(card.name)
        }.background(getBackgroundColor())
    }
}

#Preview {
    AmiiboCardView(.debugValue)
}
