//
//  AmiiboAPI+Endpoint.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 04/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation
import Core

typealias LocalEndpoint = Endpoint<AmiiboAPI.Local, Data>

extension AmiiboAPI {
    enum Local: EndpointKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {}
    }

    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {}
    }
}

// MARK: Routes
extension Endpoint where Kind == AmiiboAPI.Public, Response == AmiiboAPI.Response {
    static var amiiboList: Endpoint { "amiibo" }
}
