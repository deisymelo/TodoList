//
//  DetailViewCoordinatorTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/02/23.
//

import XCTest
@testable import TodoList

final class DetailViewCoordinatorTests: XCTestCase {

    var coordinator: DetailCoordinator!
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
        
        coreData.itemsList = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            coreData: coreData,
            itemId: "1"
        )
        
        detailCoordinator.start()
        
        XCTAssertNotNil(detailCoordinator.viewModel)
    
        let itemDetail = detailCoordinator.viewModel?.itemDetails?.value
        
        XCTAssertEqual(itemDetail?.id, "1")
        XCTAssertEqual(itemDetail?.title, "Test")
        
        let detailController = navigationController.topViewController as? DetailViewController
        XCTAssertNotNil(detailController, "should have an DetailViewController")
    }

}
