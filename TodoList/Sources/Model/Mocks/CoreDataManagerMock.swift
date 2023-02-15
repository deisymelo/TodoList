//
//  CoreDataManagerMock.swift
//  TodoList
//
//  Created by Deisy Melo on 4/01/23.
//

import Foundation
import Combine

final class CoreDataManagerMock: CoreDataManagerProtocol {
    var error: Error?
    var item: TodoItem?
    var updateStatusCheck: Bool = false
    var itemsList: [TodoItem] = []
    
    func saveItem(_ todoItem: TodoItem) {
        itemsList = [todoItem]
    }
    
    func getItems() -> [TodoItem] {
        return itemsList
    }
    
    func getItemBy(_ id: String) -> TodoItem? {
        return itemsList.first{ $0.id == id }
    }
    
    func updateStatus(_ id: String) -> AnyPublisher<TodoItem, Error> {
        updateStatusCheck = true
        if let error = error {
            return Fail<TodoItem, Error>(error: error).eraseToAnyPublisher()
        }
        
        if let item = item {
            itemsList.append(item)
            return Just(item)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<TodoItem, Error>().eraseToAnyPublisher()
    }
}
