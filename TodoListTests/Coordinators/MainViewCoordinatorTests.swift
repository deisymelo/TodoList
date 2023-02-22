//
//  MainViewCoordinatorTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest
@testable import TodoList

final class MainViewCoordinatorTests: XCTestCase {
    
    var coordinator: MainCoordinator!
    var window: UIWindow!
    var coreData: CoreDataManagerMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = .init(frame: UIScreen.main.bounds)
        coreData = CoreDataManagerMock()
    }
    
    func testStartMainView() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            coreData: coreData
        )
        
        mainCoordinator.start()
        let itemList = mainCoordinator.viewModel?.itemList.value
        
        XCTAssertNotNil(mainCoordinator.viewModel)
        XCTAssertEqual(itemList?.count ?? 0, 0)
        XCTAssertNotNil(navigationController.viewControllers.first)
        let expectedViewController = navigationController.viewControllers.first as? MainViewController
        XCTAssertNotNil(expectedViewController, "should have an MainViewController")
    }
    
    func testOpenAddItemView() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            coreData: coreData
        )
        
        mainCoordinator.start()
        mainCoordinator.addNewItemTap()
        XCTAssertEqual(mainCoordinator.childCoordinators.count, 1)
        
        let addItemCoordinator = mainCoordinator.childCoordinators.first as? AddItemCoordinator
        XCTAssertNotNil(addItemCoordinator, "should have an AddItemCoordinator")
        
        addItemCoordinator?.closeView(success: true)
        XCTAssertTrue(mainCoordinator.childCoordinators.isEmpty)
    }
    
    func testOpenDetailView() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        coreData.itemsList = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            coreData: coreData
        )
        
        mainCoordinator.start()
        mainCoordinator.showDetailBy(id: "1")
        XCTAssertEqual(mainCoordinator.childCoordinators.count, 1)
        
        let detailCoordinator = mainCoordinator.childCoordinators.first as? DetailCoordinator
        XCTAssertNotNil(detailCoordinator, "should have an DetailCoordinator")
        
        detailCoordinator?.closeView(success: true)
        XCTAssertTrue(mainCoordinator.childCoordinators.isEmpty)
    }
}
