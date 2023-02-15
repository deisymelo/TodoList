//
//  AddItemViewModelTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class AddItemViewModelTests: XCTestCase {

    var coreDataManager: CoreDataManagerMock!
    var viewModel: AddItemViewModel!
    var addItemCoordinatorProtocol: TestAddItemCoordinatorProtocol!
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManagerMock()
        addItemCoordinatorProtocol = TestAddItemCoordinatorProtocol()
        viewModel = AddItemViewModel(coreData: coreDataManager)
        viewModel.delegate = addItemCoordinatorProtocol
    }
    
    func testAddNewItemTap() {
        let newItem: TodoItem = TodoItem(id: "1", title: "Test", description: "Test", pending: true)
        viewModel.addNewItemTap(item: newItem)
        let item = coreDataManager.itemsList.first
        
        XCTAssertEqual(item?.id, newItem.id)
        XCTAssertTrue(addItemCoordinatorProtocol.additionHasBeenSuccess)
    }
}
