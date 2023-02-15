//
//  TodoItemCellTests.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class TodoItemCellTests: XCTestCase {
    
    func testSetData() {
        let item: TodoItem = TodoItem(id: "10", title: "Test 10", description: "test", pending: true)
        let cell = TodoItemCell()
        cell.setData(item)
        
        XCTAssertEqual(cell.testHooks.itemId, item.id)
        XCTAssertEqual(cell.testHooks.titleLabel, item.title)
        XCTAssertEqual(cell.testHooks.descriptionLabel, item.description)
        XCTAssertEqual(cell.testHooks.imageName, "circle")
    }
    
    func testItemNotPending() {
        let item: TodoItem = TodoItem(id: "10", title: "Test 10", description: "test", pending: false)
        let cell = TodoItemCell()
        cell.setData(item)
        
        XCTAssertEqual(cell.testHooks.itemId, item.id)
        XCTAssertEqual(cell.testHooks.titleLabel, item.title)
        XCTAssertEqual(cell.testHooks.descriptionLabel, item.description)
        XCTAssertEqual(cell.testHooks.imageName, "circle.fill")
    }
    
    func testSelectItem() {
        let item: TodoItem = TodoItem(id: "10", title: "Test 10", description: "test", pending: false)
        let cell = TodoItemCell()
        let delegate = TestTodoItemCellDelegate()
        cell.setData(item)
        cell.delegate = delegate
        
        cell.testHooks.selectItem()
        XCTAssertEqual(delegate.idItemSelected, "10")
    }
    
    func testChangeStatus() {
        let item: TodoItem = TodoItem(id: "20", title: "Test 10", description: "test", pending: false)
        let cell = TodoItemCell()
        let delegate = TestTodoItemCellDelegate()
        cell.setData(item)
        cell.delegate = delegate
        
        cell.testHooks.changeStatus()
        XCTAssertEqual(delegate.idItemChanged, "20")
    }
}
