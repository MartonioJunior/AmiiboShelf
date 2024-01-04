//
//  MyShelfView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import SwiftUI
import SwiftData

struct MyShelfView: View {
    // MARK: Variables
    @State private var selectedAmiibo: Amiibo?
    @State private var searchText = ""

    @Query(filter: #Predicate<Amiibo> { $0.onShelf },
           sort: [SortDescriptor(\Amiibo.name)])
    private var shelfAmiibos: [Amiibo]

    let columns = [GridItem](repeating: GridItem(.flexible()), count: 5)
    let insets = EdgeInsets(size: 12)

    // MARK: View Implementation
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    let filteredShelfAmiibos = search(on: shelfAmiibos, with: searchText)
                    ForEach(filteredShelfAmiibos, id: \.self) { amiibo in
                        show(amiibo).includePreview().onTapGesture {
                            selectedAmiibo = amiibo
                        }
                    }
                }
                .padding(insets)
                .searchable(text: $searchText)
            }
            .scrollBackground(.primary)

            binder($selectedAmiibo)
        } detail: {
            if let selectedAmiibo {
                AmiiboDetailView(selectedAmiibo)
            } else {
                Text("Select a figure")
            }
        }.wrap(withFooter: .secondary)
    }
}

extension MyShelfView: AmiiboExplorerView {
    typealias Subview = AmiiboThumbnailView
}

#Preview {
    MyShelfView().modelContainer(previewContainer)
}
