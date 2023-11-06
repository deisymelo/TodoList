//
//  AddItemViewModelTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class AddItemViewModelTests: XCTestCase {

    var coreDataManager: DataManagerMock!
    var viewModel: AddItemViewModel!
    var addItemCoordinatorProtocol: TestAddItemCoordinatorProtocol!
    
    override func setUpWithError() throws {
        coreDataManager = DataManagerMock()
        addItemCoordinatorProtocol = TestAddItemCoordinatorProtocol()
        viewModel = AddItemViewModel(repository: coreDataManager)
        viewModel.delegate = addItemCoordinatorProtocol
    }
    
    func testAddNewItemTap() {
        let newItem: TodoItem = TodoItem(id: "1", title: "Test", description: "Test", pending: true)
        viewModel.addNewItemTap(item: newItem)
        let item = coreDataManager.itemsList.first
        
        XCTAssertEqual(item?.id, newItem.id)
        XCTAssertTrue(addItemCoordinatorProtocol.additionHasBeenSuccess)
    }
    
    func testAddItemError() {
        let message: String = "This is an error"
        viewModel.addItemError(message)
        XCTAssertEqual(addItemCoordinatorProtocol.errorMessage, message)
    }
}
