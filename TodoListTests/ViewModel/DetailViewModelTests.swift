//
//  DetailViewModelTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class DetailViewModelTests: XCTestCase {

    var coreDataManager: CoreDataManagerMock!
    var viewModel: DetailViewModel!
    var detailCoordinatorProtocol: TestDetailCoordinatorProtocol!
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManagerMock()
        detailCoordinatorProtocol = TestDetailCoordinatorProtocol()
        
    }
    
    func testLoadItem() {
        coreDataManager.itemsList = [
            TodoItem(id: "10", title: "Test 10", description: "test", pending: false),
            TodoItem(id: "20", title: "Test 20", description: "test", pending: true)
        ]
        
        viewModel = DetailViewModel(coreData: coreDataManager, itemId: "10")
        
        viewModel.loadItem()
        
        let itemFromCoreData = coreDataManager.getItemBy("10")
        let itemFromViewModel = viewModel.itemDetails?.value
        
        XCTAssertEqual(itemFromViewModel?.id, "10")
        XCTAssertEqual(itemFromCoreData?.id, itemFromViewModel?.id)
        XCTAssertEqual(itemFromCoreData?.title, itemFromViewModel?.title)
    }
    
    func testLoadWrongItem() {
        coreDataManager.itemsList = [
            TodoItem(id: "10", title: "Test 10", description: "test", pending: false),
            TodoItem(id: "20", title: "Test 20", description: "test", pending: true)
        ]
        
        viewModel = DetailViewModel(coreData: coreDataManager, itemId: "100")
        
        viewModel.loadItem()
        
        let itemFromViewModel = viewModel.itemDetails?.value
        
        XCTAssertNil(itemFromViewModel, "This item doesn't exists")
    }
    
    func testCloseView() {
        viewModel = DetailViewModel(coreData: coreDataManager, itemId: "1")
        viewModel.delegate = detailCoordinatorProtocol
        viewModel.didDisappear()
        
        XCTAssertTrue(detailCoordinatorProtocol.closeViewCalled)
    }
}
