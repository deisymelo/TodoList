//
//  DataSourceRepository.swift
//  TodoList
//
//  Created by Deisy Melo on 5/11/23.
//
import Foundation
import Combine

protocol DataSourceProtocol {
    func saveItem(_ item: Item) -> AnyPublisher<Bool, Error>
    func getItems() -> AnyPublisher<[Item], Error>
    func getItemBy(_ id: String) -> AnyPublisher<Item?, Error>
    func updateStatus(_ id: String) -> AnyPublisher<Item, Error>
}

public enum DataError: Error {
    case notFound
    case errorLogin
    case errorSignUp
}

final class DataSourceRepository: RepositoryProtocol {
    
    let remoteDataSource: DataSourceProtocol?
    let localDataSource: DataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(localDataSource: DataSourceProtocol, remoteDataSource: DataSourceProtocol? =  nil) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func saveItem(_ item: Item) -> AnyPublisher<Bool, Error> {
        Future { promise in
            guard let remote = self.remoteDataSource else {
                _ = self.localDataSource.saveItem(item)
                promise(.success(true))
                return
            }
            
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
            guard let remote = self.remoteDataSource else {
                return promise(.success([]))
            }
            
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
        guard let remote = remoteDataSource else {
            return localDataSource.getItemBy(id)
        }
        
        return remote.getItemBy(id)
    }
    
    public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        return localDataSource.updateStatus(id)
    }
    
//    public func signup(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
//        Future { promise in
//            guard let remote = self.remoteDataSource else {
//                return promise(.success(nil))
//            }
//            
//            remote.signup(email: email, pass: pass)
//                .receive(on: DispatchQueue.main)
//                .sink { _ in
//                } receiveValue: { user in
//                    promise(.success(user))
//                }.store(in: &self.cancellables)
//        }.eraseToAnyPublisher()
//    }
//    
//    public func login(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
//        Future { promise in
//            guard let remote = self.remoteDataSource else {
//                return promise(.success(nil))
//            }
//            
//            remote.login(email: email, pass: pass)
//                .receive(on: DispatchQueue.main)
//                .sink { _ in
//                } receiveValue: { user in
//                    promise(.success(user))
//                }.store(in: &self.cancellables)
//        }.eraseToAnyPublisher()
//    }
    
}
