//
//  AddItemViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import Foundation

protocol AddItemViewModelProtocol: AnyObject {
    func addNewItemTap(item: TodoItem)
}

class AddItemViewModel: AddItemViewModelProtocol {
    
    weak var delegate: AddItemCoordinatorProtocol?
    
    func addNewItemTap(item: TodoItem) {
        let manager = CoreDataManager()
        manager.saveItem(item)
        delegate?.closeView()
    }
}

