//
//  AmiiboFigureExplorerView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI
import SwiftData

struct AmiiboFigureExplorerView: View {
    // MARK: Variables
    @State private var selectedFigure: Amiibo?
    @State private var searchText = ""

    @Query(filter: #Predicate<Amiibo> { $0.type != "Card" },
           sort: [SortDescriptor(\Amiibo.name)])
    private var figures: [Amiibo]

    // MARK: View Implementation
    var body: some View {
        NavigationSplitView {
            List(search(on: figures, with: searchText), id: \.self, selection: $selectedFigure) { amiibo in
                show(amiibo).includePreview()
                    .listRowBackground(.primary)
            }
            .searchable(text: $searchText)
            .navigationTitle("Figures")
            .scrollBackground(.primary)
        } detail: {
            if let selectedFigure {
                AmiiboDetailView(selectedFigure)
            } else {
                Text("Select a figure")
            }
        }.wrap(withFooter: .secondary)
    }
}

extension AmiiboFigureExplorerView: AmiiboExplorerView {
    typealias Subview = AmiiboFigureView
}

// MARK: XCode Previews
#Preview {
    return AmiiboFigureExplorerView().modelContainer(previewContainer)
}
