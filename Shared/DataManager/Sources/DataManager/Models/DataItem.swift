//
//  File.swift
//  
//
//  Created by Andres Rojas on 2/05/23.
//

import Foundation

struct DataItem: Item {
    let id: String?
    let title: String
    let description: String
    var pending: Bool

    init(
        id: String? = nil,
        title: String,
        description: String,
        pending: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.pending = pending
    }
}

struct Failure: Error {
    let message: String
}
