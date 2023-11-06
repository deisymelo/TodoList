//
//  AddItemViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import Foundation

protocol AddItemViewModelProtocol: AnyObject {
    func addNewItemTap(item: TodoItem)
    func addItemError(_ msn: String)
}

class AddItemViewModel: AddItemViewModelProtocol {
    
    weak var delegate: AddItemCoordinatorProtocol?
    var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func addNewItemTap(item: TodoItem) {
        repository.saveItem(item)
        delegate?.closeView(success: true)
    }
    
    func addItemError(_ msn: String) {
        delegate?.displayErrorView(message: msn)
    }
}
