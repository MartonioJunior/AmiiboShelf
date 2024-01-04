//
//  ContentView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: View Initializationend
    var body: some View {
        NavigationStack {
            TabView {
                entry(for: AmiiboFigureExplorerView(), with: .figureIcon, and: "Figures")
                entry(for: AmiiboCardExplorerView(), with: .cardIcon, and: "Cards")
                entry(for: MyShelfView(), with: .shelfIcon, and: "My Shelf")
            }.background(.secondary)
        }.wrap(withHeader: .primary, andFooter: .secondary)
    }

    // MARK: Methods
    @ViewBuilder func entry(for view: some View, with icon: UIImage, and label: String) -> some View {
        view.tabItem {
            Image(uiImage: icon)
            Text(label)
        }
    }
}

#Preview {
    ContentView().modelContainer(previewContainer)
}
