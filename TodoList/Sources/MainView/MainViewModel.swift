//
//  MainViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 26/10/22.
//

import Foundation

protocol MainViewModelProtocol {
    var itemList: Box<[TodoItem]> { get set }
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
    var delegate: MainViewModelNavigationDelegate?
    
    init() {
        let list = CoreDataManager().fetchItems()
        itemList.value = list
    }
    
    func addNewItemTap() {
        delegate?.addNewItemTap()
    }
}
