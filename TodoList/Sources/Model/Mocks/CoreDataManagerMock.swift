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
        let id = "1"
        let item = TodoItem(
            id: id,
            title: todoItem.title,
            description: todoItem.description
        )
        itemsList = [item]
    }
    
    func getItems() -> [TodoItem] {
        return itemsList
    }
    
    func getItemBy(_ id: String) -> TodoItem? {
        return itemsList.first{ $0.id == id }
    }
    
    func updateStatus(_ id: String) -> AnyPublisher<TodoItem, Error> {
        updateStatusCheck = true
        if let itemToEdit = itemsList.first(where: { $0.id == id }) {
            item = itemToEdit
            item?.pending = !itemToEdit.pending
        }
        
        if let error = error {
            return Fail<TodoItem, Error>(error: error).eraseToAnyPublisher()
        }
        
        if let item = item {
            itemsList.removeAll()
            itemsList.append(item)
            return Just(item)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<TodoItem, Error>().eraseToAnyPublisher()
    }
}

extension CoreDataManagerMock {
   
    func getListWithItems() -> [TodoItem] {
        return [.init(title: "Item 1", description: "This is the item one!")]
    }

}
