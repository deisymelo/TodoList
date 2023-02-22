//
//  AddItemViewControllerTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest
@testable import TodoList

final class AddItemViewControllerTests: XCTestCase {

    func testTappedAddItemButton() {
        let viewModel = TestAddItemViewModelProtocol()
        
        let viewController = AddItemViewController(viewModel: viewModel)
        viewController.testHooks.titleTextField.text = "Task 1"
        viewController.testHooks.descriptionTextField.text = "Description 1"
        viewController.testHooks.saveItem()
        XCTAssertTrue(viewModel.addNewItemTapped)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
        XCTAssertEqual(viewModel.newItem?.title, "Task 1")
    }
    
    func testTappedAddItemButtonError() {
        let viewModel = TestAddItemViewModelProtocol()
        
        let viewController = AddItemViewController(viewModel: viewModel)
        viewController.testHooks.saveItem()
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
}
