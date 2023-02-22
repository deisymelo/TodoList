//
//  AddItemViewModelTest+Protocols.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class TestAddItemViewModelProtocol: AddItemViewModelProtocol {
    var addNewItemTapped: Bool =  false
    var newItem: TodoItem?
    var errorMessage: String = ""
    
    func addNewItemTap(item: TodoItem) {
        addNewItemTapped = true
        newItem = item
    }
    
    func addItemError(_ msn: String) {
        errorMessage = msn
    }
}

class TestAddItemCoordinatorProtocol: AddItemCoordinatorProtocol {
    var additionHasBeenSuccess: Bool = false
    var errorMessage: String = ""
    
    func closeView(success: Bool) {
        additionHasBeenSuccess = success
    }
    
    func displayErrorView(message: String) {
        errorMessage = message
    }
}
