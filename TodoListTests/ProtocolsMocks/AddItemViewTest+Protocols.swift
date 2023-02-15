//
//  AddItemViewModelTest+Protocols.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class TestAddItemViewModelProtocol: AddItemViewModelProtocol {
    func addNewItemTap(item: TodoItem) {
    }
    
    func addItemError(_ msn: String) {
    }
}

class TestAddItemCoordinatorProtocol: AddItemCoordinatorProtocol {
    var additionHasBeenSuccess: Bool = false
    
    func closeView(success: Bool) {
        additionHasBeenSuccess = success
    }
}
