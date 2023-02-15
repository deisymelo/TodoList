//
//  MainViewControllerTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class MainViewControllerTests: XCTestCase {
    
    func testTappedAddItemButton() {
        let viewModel = TestMainViewModelProtocol()
        viewModel.itemList.value = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        let viewController = MainViewController(viewModel: viewModel)
        viewController.testHooks.tappedAddItemButton()
        XCTAssertEqual(viewController.testHooks.numberOfRowsInSection, 2)
        XCTAssertTrue(viewModel.addNewItemTapped)
    }
    
    func testChangeStatus() {
        let viewModel = TestMainViewModelProtocol()
        let viewController = MainViewController(viewModel: viewModel)
        viewController.testHooks.changeStatus("100")
        XCTAssertEqual(viewModel.itemChanged, "100")
    }
    
    func testShowDetailById() {
        let viewModel = TestMainViewModelProtocol()
        let viewController = MainViewController(viewModel: viewModel)
        viewController.testHooks.selectItem("200")
        XCTAssertEqual(viewModel.idItemShow, "200")
    }
}
