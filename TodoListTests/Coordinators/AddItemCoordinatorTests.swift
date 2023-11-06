//
//  AddItemCoordinatorTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest
@testable import TodoList

final class AddItemCoordinatorTests: XCTestCase {

    var coordinator: AddItemCoordinator!
    var window: UIWindow!
    var coreData: DataManagerMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = .init(frame: UIScreen.main.bounds)
        coreData = DataManagerMock()
    }
    
    func testStartMainView() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let addItemCoordinator = AddItemCoordinator(
            navigationController: navigationController,
            repository: coreData
        )
        
        addItemCoordinator.start()
        
        XCTAssertNotNil(addItemCoordinator.viewModel)
        let addItemController = navigationController.topViewController as? AddItemViewController
        XCTAssertNotNil(addItemController, "should have an AddItemCoordinator")
    }

}
