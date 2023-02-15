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
    
    func didDisappear() {
    }
}

class TestDetailCoordinatorProtocol: DetailCoordinatorProtocol {
    var closeViewCalled: Bool = false
    
    func closeView(success: Bool) {
        closeViewCalled = true
    }
}
