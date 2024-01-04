//
//  AmiiboView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Core
import SwiftUI

struct AmiiboDetailView: AmiiboView {
    // MARK: Variables
    @State internal var amiibo: Amiibo

    var columns = [GridItem](repeating: GridItem(.flexible()), count: 2)

    // MARK: Initializers
    init(_ amiibo: Amiibo) {
        self.amiibo = amiibo
    }

    // MARK: View Implementation
    var body: some View {
        VStack {
            image().resizable().scaledToFit()
            Text(amiibo.name).font(.largeTitle)
            Text(amiibo.amiiboSeries).font(.headline)
            Text(amiibo.gameSeries).font(.subheadline)
            LazyVGrid(columns: columns, spacing: 12) {
                release(date: amiibo.naRelease, for: .flagNA)
                release(date: amiibo.jpRelease, for: .flagJP)
                release(date: amiibo.euRelease, for: .flagEU)
                release(date: amiibo.auRelease, for: .flagAU)
            }
            addToShelfButton().frame(maxWidth: .infinity, maxHeight: 48)
        }.background(.primary)
    }

    // MARK: Methods
    func release(date: Date?, for image: UIImage) -> some View {
        return HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            label(for: date)
        }.frame(maxHeight: 48)
    }
}

#Preview {
    AmiiboDetailView(.debugValue)
}
