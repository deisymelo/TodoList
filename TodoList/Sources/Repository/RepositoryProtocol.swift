//
//  RepositoryProtocol.swift
//  TodoList
//
//  Created by Deisy Melo on 5/11/23.
//

import Combine

public protocol RepositoryProtocol {
    func saveItem(_ item: Item)
    func getItems() -> [Item]
    func getItemBy(_ id: String) -> Item?
    func updateStatus(_ id: String) -> AnyPublisher<Item, Error>
}
