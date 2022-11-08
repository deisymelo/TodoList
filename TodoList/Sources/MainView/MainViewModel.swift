//
//  MainViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 26/10/22.
//

import Foundation

protocol MainViewModelProtocol {
    var itemList: Box<[TodoItem]> { get set }
    var numberOfRowsInSection: Int { get }
    
    func getItemBy(_ indexPath: IndexPath) -> TodoItem?
    func addNewItemTap()
}

protocol MainViewModelNavigationDelegate {
    func addNewItemTap()
}

protocol MainViewModelCoordinatorProtocol {
    var delegate: MainViewModelNavigationDelegate? { get set }
}

class MainViewModel: MainViewModelProtocol, MainViewModelCoordinatorProtocol {
    
    var itemList: Box<[TodoItem]> = Box([])
    
    var numberOfRowsInSection: Int {
        itemList.value.count
    }
    
    var delegate: MainViewModelNavigationDelegate?
    
    init() {
        let list = CoreDataManager().fetchItems()
        itemList.value = list
    }
    
    func getItemBy(_ indexPath: IndexPath) -> TodoItem? {
        return itemList.value[indexPath.row]
    }
    
    func addNewItemTap() {
        delegate?.addNewItemTap()
    }
}
