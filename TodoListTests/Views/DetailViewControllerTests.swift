//
//  DetailViewControllerTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest
@testable import TodoList

final class DetailViewControllerTests: XCTestCase {

    func testItemDetail() {
        let viewModel = TestDetailViewModelProtocol()
        viewModel.itemDetails = Box(TodoItem(title: "Test", description: "Test"))
        
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.setupBindings()
        XCTAssertEqual(viewController.testHooks.titleLabel, "Test")
        XCTAssertEqual(viewController.testHooks.descriptionLabel, "Test")
        XCTAssertEqual(viewController.testHooks.statusLabel, "Pending")
    }

}
