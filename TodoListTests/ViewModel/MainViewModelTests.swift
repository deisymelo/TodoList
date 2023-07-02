//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 20/10/22.
//

import XCTest
@testable import TodoList

class MainViewModelTests: XCTestCase {

    var coreDataManager: CoreDataManagerMock!
    var viewModel: MainViewModel!
    var mainViewModelNavigationDelegate: TestMainViewModelNavigationDelegate!
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManagerMock()
        mainViewModelNavigationDelegate = TestMainViewModelNavigationDelegate()
        viewModel = MainViewModel(coreData: coreDataManager)
        viewModel.delegate = mainViewModelNavigationDelegate
    }
    
    func testUpdateItem() {
        coreDataManager.item = TodoItem(id: "1", title: "Test", description: "test", pending: false)
        viewModel.changeStatus(id: "1")
        XCTAssertTrue(coreDataManager.updateStatusCheck)
        XCTAssertFalse(coreDataManager.itemsList.isEmpty)
        XCTAssertEqual(coreDataManager.itemsList.first?.id, "1")
    }
    
    func testGetItems() {
        coreDataManager.itemsList = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        viewModel.loadItems()
        let list = viewModel.itemList.value
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.first?.id, "1")
        XCTAssertEqual(list.first?.pending, false)
        XCTAssertEqual(list.last?.id, "2")
        XCTAssertEqual(list.last?.pending, true)
    }
    
    func testGetItemByPosition() {
        coreDataManager.itemsList = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        viewModel.loadItems()
        let item = viewModel.getItemBy(IndexPath(row: 1, section: 0))
        XCTAssertEqual(item?.id, "2")
        XCTAssertEqual(item?.pending, true)
    }
    
    func testAddNewItemTap() {
        viewModel.addNewItemTap()
        XCTAssertTrue(mainViewModelNavigationDelegate.isAddNewItemTaped)
    }
    
    func testShowDetailById() {
        viewModel.showDetailBy(id: "10")
        XCTAssertTrue(mainViewModelNavigationDelegate.isShowDetailByCalled)
        XCTAssertEqual(mainViewModelNavigationDelegate.itemId, "10")
    }
    
    func testNumberOfRowsInSection() {
        coreDataManager.itemsList = [
            TodoItem(id: "1", title: "Test", description: "test", pending: false),
            TodoItem(id: "2", title: "Test", description: "test", pending: true)
        ]
        
        viewModel.loadItems()
        XCTAssertEqual(viewModel.numberOfRowsInSection, 2)
    }
    
    func testUpdateStatusError() {
        coreDataManager.error = Failure(message: "Item doesn't founded")
        let expectation: XCTestExpectation = XCTestExpectation(description: "Wait until delegate respons")
        mainViewModelNavigationDelegate.expectation = expectation
        
        viewModel.changeStatus(id: "2")
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(mainViewModelNavigationDelegate.errorMessage, "Item doesn't founded")
    }

}
