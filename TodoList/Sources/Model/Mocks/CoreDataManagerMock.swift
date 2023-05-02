//
//  CoreDataManagerMock.swift
//  TodoList
//
//  Created by Deisy Melo on 4/01/23.
//

import Foundation
import Combine
import DataManager

final class CoreDataManagerMock: CoreDataManagerProtocol {
    var error: Error?
    var item: TodoItem?
    var updateStatusCheck: Bool = false
    var itemsList: [TodoItem] = []
    
    public func saveItem(_ item: Item) {
        let id = "1"
        let item = TodoItem(
            id: id,
            title: item.title,
            description: item.description
        )
        itemsList = [item]
    }
    
    public func getItems() -> [Item] {
        return itemsList
    }
    
    public func getItemBy(_ id: String) -> Item? {
        return itemsList.first{ $0.id == id }
    }
    
   public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        updateStatusCheck = true
        if let itemToEdit = itemsList.first(where: { $0.id == id }) {
            item = itemToEdit
            item?.pending = !itemToEdit.pending
        }
        
        if let error = error {
            return Fail<Item, Error>(error: error).eraseToAnyPublisher()
        }
        
        if let item = item {
            itemsList.removeAll()
            itemsList.append(item)
            return Just(item)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<Item, Error>().eraseToAnyPublisher()
    }
}

extension CoreDataManagerMock {
   
    func getListWithItems() -> [TodoItem] {
        return [.init(title: "Item 1", description: "This is the item one!")]
    }

}
