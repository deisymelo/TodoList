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

    func testListItemsFlow() throws {
        // UI tests must launch the application that they test.
        app.launch()
        let addButton = app.buttons["mainViewController.button.addItem"]
        let textfieldTitle = app.textFields["addItemController.textField.title"]
        let textfieldDescription = app.textFields["addItemController.textField.description"]
        let button = app.buttons["addItemController.button.save"]
        
        addButton.tap()
        textfieldTitle.tap()
        textfieldTitle.typeText("Hola")
        textfieldDescription.tap()
        textfieldDescription.typeText("Mundo")
        button.tap()
        addButton.waitForExistence(timeout: 2)
    }
}
