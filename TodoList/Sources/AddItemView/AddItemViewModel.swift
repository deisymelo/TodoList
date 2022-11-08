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
    var coreData: CoreDataManagerProtocol = CoreDataManager()

    func addNewItemTap(item: TodoItem) {
        coreData.saveItem(item)
        delegate?.closeView()
    }
    
    func addItemError(_ msn: String) {
        //Todo: Display error alert
    }
}

