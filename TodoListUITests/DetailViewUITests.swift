//
//  DetailViewUITests.swift
//  TodoListUITests
//
//  Created by Deisy Melo on 13/03/23.
//

import XCTest

final class DetailViewUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITests")
    }

    func testItemDetailFlow() throws {
        // UI tests must launch the application that they test.
        app.launch()
        // mainView components
        let addButton = app.buttons["mainViewController.button.addItem"]
        let tableDescription = app.tables["mainViewController.table"]
        
        // addItemView components
        let textfieldTitle = app.textFields["addItemController.textField.title"]
        let textfieldDescription = app.textFields["addItemController.textField.description"]
        let saveButton = app.buttons["addItemController.button.save"]
        
        // detailView components
        let detailTitleLabel = app.staticTexts["detailView.lable.title"]
        let detailDescriptionLabel = app.staticTexts["detailView.lable.description"]
        let detailStatusLabel = app.staticTexts["detailView.lable.status"]
        
        //Open mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        addButton.tap()
        
        //Open AddItemView
        textfieldTitle.tap()
        textfieldTitle.typeText("Item 1")
        textfieldDescription.tap()
        textfieldDescription.typeText("This is the item one!")
        saveButton.tap()
        
        //Check if the new item is displaying on mainView
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.waitForExistence(timeout: 2))
        XCTAssertTrue(tableDescription.cells.count == 1)
        
        let todoItemCell = tableDescription.cells["TodoItemCell0"]
        XCTAssertTrue(todoItemCell.exists)
        
        let selectButton = todoItemCell.buttons["TodoItemCell.button.select"]
        XCTAssertTrue(selectButton.waitForExistence(timeout: 2))
        
        selectButton.tap()
        
        //Open Detail view
        XCTAssertTrue(detailTitleLabel.waitForExistence(timeout: 2))
        XCTAssertTrue(detailDescriptionLabel.waitForExistence(timeout: 2))
        XCTAssertTrue(detailStatusLabel.waitForExistence(timeout: 2))
        
        XCTAssertEqual(detailTitleLabel.label, "Item 1")
        XCTAssertEqual(detailDescriptionLabel.label, "This is the item one!")
        XCTAssertEqual(detailStatusLabel.label, "Pending")
    }
}
