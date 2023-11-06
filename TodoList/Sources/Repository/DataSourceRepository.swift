//
//  DataSourceRepository.swift
//  TodoList
//
//  Created by Deisy Melo on 5/11/23.
//

import Combine

public protocol DataSourceProtocol {
    func saveItem(_ item: Item)
    func getItems() -> [Item]
    func getItemBy(_ id: String) -> Item?
    func updateStatus(_ id: String) -> AnyPublisher<Item, Error>
}

public class DataSourceRepository: RepositoryProtocol {
    
    let remoteDataSource: DataSourceProtocol?
    let localDataSource: DataSourceProtocol
    
    init(localDataSource: DataSourceProtocol, remoteDataSource: DataSourceProtocol? =  nil) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func saveItem(_ item: Item) {
        localDataSource.saveItem(item)
    }
    
    public func getItems() -> [Item] {
        return localDataSource.getItems()
    }
    
    public func getItemBy(_ id: String) -> Item? {
        return localDataSource.getItemBy(id)
    }
    
    public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        return localDataSource.updateStatus(id)
    }
    
}
