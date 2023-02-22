//
//  DetailViewTest+Protocols.swift
//  TodoListTests
//
//  Created by Deisy Melo on 17/01/23.
//

import XCTest
@testable import TodoList

class TestDetailViewModelProtocol: DetailViewModelProtocol {
    var itemDetails: Box<TodoItem>?
    var didDisappearCalled: Bool = false
    
    func didDisappear() {
        didDisappearCalled = true
    }
}

class TestDetailCoordinatorProtocol: DetailCoordinatorProtocol {
    var closeViewCalled: Bool = false
    
    func closeView(success: Bool) {
        closeViewCalled = true
    }
}
