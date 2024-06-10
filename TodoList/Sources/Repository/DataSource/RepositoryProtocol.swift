//
//  RepositoryProtocol.swift
//  TodoList
//
//  Created by Deisy Melo on 5/11/23.
//

import Combine

public protocol RepositoryProtocol {
    func saveItem(_ item: Item) -> AnyPublisher<Bool, Error>
    func getItems() -> AnyPublisher<[Item], Error>
    func getItemBy(_ id: String) -> AnyPublisher<Item?, Error>
    func updateStatus(_ id: String) -> AnyPublisher<Item, Error>
}
