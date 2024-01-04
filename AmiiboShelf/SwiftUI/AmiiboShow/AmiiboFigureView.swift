//
//  AmiiboFigureView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI

struct AmiiboFigureView: AmiiboView {
    // MARK: Variables
    @State private var figure: Amiibo

    // MARK: Properties
    var amiibo: Amiibo { figure }

    // MARK: Constructors
    init(_ figure: Amiibo) {
        self.figure = figure
    }

    // MARK: View Implementation
    var body: some View {
        HStack {
            image().resizable().scaledToFit()
            VStack(alignment: .leading) {
                write(figure.name).font(.title)
                write(figure.amiiboSeries).font(.headline)
                write(figure.gameSeries).font(.body)
            }.padding()
            Spacer()
        }.frame(minHeight: 50, idealHeight: 70, maxHeight: 100)
        .background(getBackgroundColor())
    }

    // MARK: Methods
    func write(_ text: String) -> some View {
        Text(text).frame(alignment: .trailing)
    }
}

#Preview {
    AmiiboFigureView(.debugValue)
}
