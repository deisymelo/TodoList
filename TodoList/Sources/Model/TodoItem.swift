//
//  TodoItem.swift
//  TodoList
//
//  Created by Deisy Melo on 21/10/22.
//

import Foundation

struct TodoItem {
    let id: String?
    let title: String
    let description: String
    var pending: Bool
    
    init(id: String? = nil,
         title: String,
         description: String,
         pending: Bool = true) {
        self.id = id
        self.title = title
        self.description = description
        self.pending = pending
    }
}
