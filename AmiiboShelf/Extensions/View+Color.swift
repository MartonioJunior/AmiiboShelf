//
//  View+Color.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 13/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func background(_ color: ColorResource) -> some View {
        self.background(Color(color))
    }

    func edgeTint(_ color: ColorResource) -> some View {
        Rectangle().frame(height: 0).background(Color(color))
    }

    func listRowBackground(_ color: ColorResource) -> some View {
        self.listRowBackground(Color(color))
    }

    func scrollBackground(_ color: ColorResource) -> some View {
        self.scrollContentBackground(.hidden).background(color)
    }

    func wrap(withHeader color: ColorResource) -> some View {
        self.safeAreaInset(edge: .top, spacing: 0) {
            edgeTint(color)
        }
    }

    func wrap(withFooter color: ColorResource) -> some View {
        self.safeAreaInset(edge: .bottom, spacing: 0) {
            edgeTint(color)
        }
    }

    func wrap(headerAndFooter color: ColorResource) -> some View {
        wrap(withHeader: color, andFooter: color)
    }

    func wrap(withHeader headerColor: ColorResource, andFooter footerColor: ColorResource) -> some View {
        self.safeAreaInset(edge: .top, spacing: 0) {
            edgeTint(headerColor)
        }.safeAreaInset(edge: .bottom, spacing: 0) {
            edgeTint(footerColor)
        }
    }
}
