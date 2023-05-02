//
//  AddItemViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import Foundation
import DataManager

protocol AddItemViewModelProtocol: AnyObject {
    func addNewItemTap(item: TodoItem)
    func addItemError(_ msn: String)
}

class AddItemViewModel: AddItemViewModelProtocol {
    
    weak var delegate: AddItemCoordinatorProtocol?
    var coreData: CoreDataManagerProtocol
    
    init(coreData: CoreDataManagerProtocol) {
        self.coreData = coreData
    }

    func addNewItemTap(item: TodoItem) {
        coreData.saveItem(item)
        delegate?.closeView(success: true)
    }
    
    func addItemError(_ msn: String) {
        delegate?.displayErrorView(message: msn)
    }
}

