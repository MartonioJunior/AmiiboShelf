//
//  View+Interaction.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 14/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func binder<T: Hashable>(_ binding: Binding<T?>) -> some View {
        List(selection: binding) {}.frame(height: 0)
    }
}
