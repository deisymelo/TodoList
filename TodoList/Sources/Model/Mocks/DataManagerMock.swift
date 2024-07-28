//
//  CoreDataManagerMock.swift
//  TodoList
//
//  Created by Deisy Melo on 4/01/23.
//

import Foundation
import Combine

final class DataManagerMock: RepositoryProtocol {
    var error: Error?
    var item: TodoItem?
    var updateStatusCheck: Bool = false
    var itemsList: [TodoItem] = []
    var cleanDataIsCalled: Bool = false

    public func saveItem(_ item: Item) -> AnyPublisher<Bool, Error> {
        let id = "1"
        let item = TodoItem(
            id: id,
            title: item.title,
            description: item.description
        )
        itemsList = [item]
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getItems() -> AnyPublisher<[Item], Error> {
        return Just(itemsList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getItemBy(_ id: String) -> AnyPublisher<Item?, Error> {
        return Just(itemsList.first { $0.id == id })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
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
    
    func signup(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
        Future { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
        Future { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }

    func cleanData() {
        cleanDataIsCalled = true
    }
}

extension DataManagerMock {
   
    func getListWithItems() -> [TodoItem] {
        return [.init(title: "Item 1", description: "This is the item one!")]
    }

}
