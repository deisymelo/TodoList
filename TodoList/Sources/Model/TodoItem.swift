//
//  TodoItem.swift
//  TodoList
//
//  Created by Deisy Melo on 21/10/22.
//

import Foundation

enum TodoStatus: String {
    case pending
    case finished
}

struct TodoItem {
    let title: String
    let description: String
    let status: TodoStatus
    
    init(title: String,
         description: String,
         status: TodoStatus = .pending) {
        self.title = title
        self.description = description
        self.status = status
    }
}
