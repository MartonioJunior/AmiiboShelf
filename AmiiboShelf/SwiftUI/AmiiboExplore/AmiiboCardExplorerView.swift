//
//  AmiiboCardExplorerView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 20/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Core
import SwiftUI
import SwiftData

struct AmiiboCardExplorerView: View {
    // MARK: Variables
    @State private var selectedCard: Amiibo?
    @State private var searchText = ""

    @Query(filter: #Predicate<Amiibo> { $0.type == "Card" },
           sort: [SortDescriptor(\Amiibo.name)])
    private var cards: [Amiibo]

    let columns: [GridItem] = [GridItem](repeating: GridItem(.flexible()), count: 3)
    let insets = EdgeInsets(size: 12)

    // MARK: View Implementation
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(search(on: cards, with: searchText), id: \.self) { card in
                        show(card).includePreview().onTapGesture {
                            selectedCard = card
                        }
                    }
                }
                .padding(insets)
                .searchable(text: $searchText)
            }
            .navigationTitle("Figures")
            .scrollBackground(.primary)
        } detail: {
            if let selectedCard {
                AmiiboDetailView(selectedCard)
            } else {
                Text("Select a card")
            }
        }.safeAreaInset(edge: .bottom, spacing: 0) {
            binder($selectedCard)
        }.wrap(withFooter: .secondary)
    }
}

// MARK: AmiiboExplorerView
extension AmiiboCardExplorerView: AmiiboExplorerView {
    typealias Subview = AmiiboCardView
}

// MARK: XCode Preview
@available(iOS 17, *)
#Preview {
    return AmiiboCardExplorerView().modelContainer(previewContainer)
}
