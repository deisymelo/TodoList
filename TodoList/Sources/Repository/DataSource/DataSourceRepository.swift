//
//  DataSourceRepository.swift
//  TodoList
//
//  Created by Deisy Melo on 5/11/23.
//
import Foundation
import Combine

protocol DataSourceProtocol {
    var userId: String? { get set }
    func saveItem(_ item: Item) -> AnyPublisher<Bool, Error>
    func getItems() -> AnyPublisher<[Item], Error>
    func getItemBy(_ id: String) -> AnyPublisher<Item?, Error>
    func updateStatus(_ id: String) -> AnyPublisher<Item, Error>
    func cleanData()
}

public enum DataError: Error {
    case notFound
    case userError
    case errorSignUp
    case errorLogin
}

final class DataSourceRepository: RepositoryProtocol {
    
    var remoteDataSource: DataSourceProtocol?
    let localDataSource: DataSourceProtocol
    let userSession: UserSession
    
    private var cancellables = Set<AnyCancellable>()
    
    init(localDataSource: DataSourceProtocol, 
         remoteDataSource: DataSourceProtocol? =  nil,
         userSession: UserSession) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.userSession = userSession
    }
    
    func cleanData() {
        localDataSource.cleanData()
    }
    
    public func saveItem(_ item: Item) -> AnyPublisher<Bool, Error> {
        Future { promise in
            guard var remote = self.remoteDataSource else {
                _ = self.localDataSource.saveItem(item)
                promise(.success(true))
                return
            }
            
            remote.userId = self.userSession.getCurrentUser()
            remote.saveItem(item)
                .receive(on: DispatchQueue.main)
                .sink { result in
                    if case .finished = result {
                        _ = self.localDataSource.saveItem(item)
                    }
                    promise(.success(true))
                } receiveValue: { _ in
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    public func getItems() -> AnyPublisher<[Item], Error> {
        Future { promise in
            guard var remote = self.remoteDataSource else {
                return promise(.success([]))
            }
            
            remote.userId = self.userSession.getCurrentUser()
            remote.getItems()
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { list in
                    if list.isEmpty {
                        return promise(.success([]))
                    }
                    promise(.success(list))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    public func getItemBy(_ id: String) -> AnyPublisher<Item?, Error> {
        guard var remote = remoteDataSource else {
            return localDataSource.getItemBy(id)
        }
        
        remote.userId = self.userSession.getCurrentUser()
        return remote.getItemBy(id)
    }
    
    public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        return localDataSource.updateStatus(id)
    }
    
}
