//
//  MainViewUITest.swift
//  TodoListUITests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest

final class MainViewUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITests")
        
    }

    func testTableWithEmptyState() throws {
        // UI tests must launch the application that they test.
        app.launch()
        let tableDescription = app.tables["mainViewController.table"]
        let emptyStateLabel = tableDescription.staticTexts["tableView.emptyStateLabel"]
        
        XCTAssertTrue(emptyStateLabel.exists)
        XCTAssertEqual(emptyStateLabel.label, "There aren't elements")
    }
    
    func testChangeItemStatusFlow() throws {
        // UI tests must launch the application that they test.
        app.launch()
        // mainView components
        let addButton = app.buttons["mainViewController.button.addItem"]
        let tableDescription = app.tables["mainViewController.table"]
        
        // addItemView components
        let textfieldTitle = app.textFields["addItemController.textField.title"]
        let textfieldDescription = app.textFields["addItemController.textField.description"]
        let saveButton = app.buttons["addItemController.button.save"]
        
        // Open mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        addButton.tap()
        
        // Open AddItemView
        textfieldTitle.tap()
        textfieldTitle.typeText("Item 1")
        textfieldDescription.tap()
        textfieldDescription.typeText("This is the item one!")
        saveButton.tap()
        
        // Check if the new item is displaying on mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.cells.count == 1)
        
        let todoItemCell = tableDescription.cells["TodoItemCell0"]
        XCTAssertTrue(todoItemCell.exists)
        
        let statusButton = todoItemCell.buttons["TodoItemCell.button.status"]
        XCTAssertTrue(statusButton.waitForExistence(timeout: 2))
        
        XCTAssertTrue(todoItemCell.buttons["circle"].exists)
        XCTAssertFalse(todoItemCell.buttons["circle.fill"].exists)
        
        statusButton.tap()
        
        XCTAssertFalse(todoItemCell.buttons["circle"].exists)
        XCTAssertFalse(todoItemCell.buttons["circle.fill"].exists)
    }
}
