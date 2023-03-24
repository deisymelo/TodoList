//
//  TodoListUITests.swift
//  TodoListUITests
//
//  Created by Deisy Melo on 20/10/22.
//

import XCTest

class AddItemViewUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITests")
    }

    func testAddItemFlow() throws {
        // UI tests must launch the application that they test.
        app.launch()
        // mainView components
        let addButton = app.buttons["mainViewController.button.addItem"]
        let tableDescription = app.tables["mainViewController.table"]
        let emptyStateLabel = tableDescription.staticTexts["tableView.emptyStateLabel"]
        
        // addItemView components
        let textfieldTitle = app.textFields["addItemController.textField.title"]
        let textfieldDescription = app.textFields["addItemController.textField.description"]
        let saveButton = app.buttons["addItemController.button.save"]
        
        //Open mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        XCTAssertTrue(emptyStateLabel.exists)
        addButton.tap()
        
        //Open AddItemView
        textfieldTitle.tap()
        textfieldTitle.typeText("Hola")
        textfieldDescription.tap()
        textfieldDescription.typeText("Mundo")
        saveButton.tap()
        
        //Check if the new item is displaying on mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        XCTAssertFalse(emptyStateLabel.exists)
        
        XCTAssertTrue(tableDescription.cells.count == 1)
        
        let todoItemCell = tableDescription.cells["TodoItemCell0"]
        XCTAssertTrue(todoItemCell.exists)
        
        let descriptionLabelCell = todoItemCell.staticTexts["TodoItemCell.descriptionLabel"]
        let titleLabelCell = todoItemCell.staticTexts["TodoItemCell.titleLabel"]
        
        XCTAssertTrue(titleLabelCell.exists)
        XCTAssertTrue(descriptionLabelCell.exists)
        
        XCTAssertEqual(titleLabelCell.label, "Hola")
        XCTAssertEqual(descriptionLabelCell.label, "Mundo")
    }
    
    func testAddItemAlertError() throws {
        // UI tests must launch the application that they test.
        app.launch()
        // mainView components
        let addButton = app.buttons["mainViewController.button.addItem"]
        
        // addItemView components
        let saveButton = app.buttons["addItemController.button.save"]
        
        //Open mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        addButton.tap()
        
        //Try to add an item without information
        saveButton.tap()
        let alertButton = app.alerts.buttons["alertView.button.close"]
        XCTAssertTrue(alertButton.waitForExistence(timeout: 2))
    }
}
