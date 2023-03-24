//
//  MainViewModelTest+Protocols.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class TestMainViewModelProtocol: MainViewModelProtocol {
    var itemList: Box<[TodoItem]> = Box([])
    var numberOfRowsInSection: Int {
        itemList.value.count
    }
    var addNewItemTapped: Bool = false
    var idItemShow: String = "0"
    var itemChanged: String = "0"
    
    func getItemBy(_ indexPath: IndexPath) -> TodoItem? {
        itemList.value[indexPath.row]
    }
    
    func addNewItemTap() {
        addNewItemTapped.toggle()
    }
    
    func showDetailBy(id: String) {
        idItemShow = id
    }
    
    func changeStatus(id: String) {
        itemChanged = id
    }
}

class TestMainViewModelNavigationDelegate: MainViewModelNavigationDelegate {
    var isAddNewItemTaped: Bool = false
    var isShowDetailByCalled: Bool = false
    var itemId: String = ""
    var errorMessage: String = ""
    var expectation: XCTestExpectation!
    
    func addNewItemTap() {
        isAddNewItemTaped.toggle()
    }
    
    func showDetailBy(id: String) {
        isShowDetailByCalled.toggle()
        itemId = id
    }
    
    func displayError(msn: String) {
        errorMessage = msn
        expectation.fulfill()
    }
}

class TestTodoItemCellDelegate: TodoItemCellDelegate {
    var idItemSelected: String = "0"
    var idItemChanged: String = "0"
    
    func changeStatus(_ id: String) {
        idItemChanged = id
    }
    
    func selectItem(_ id: String) {
        idItemSelected = id
    }
}
