//
//  AddItemViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import Foundation
import Combine

protocol AddItemViewModelProtocol: AnyObject {
    func addNewItemTap(item: TodoItem)
    func addItemError(_ msn: String)
}

class AddItemViewModel: AddItemViewModelProtocol {
    
    weak var delegate: AddItemCoordinatorProtocol?
    var repository: RepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func addNewItemTap(item: TodoItem) {
        repository.saveItem(item)
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.delegate?.closeView(success: true)
            } receiveValue: { _ in
            }.store(in: &cancellables)
    }
    
    func addItemError(_ msn: String) {
        delegate?.displayErrorView(message: msn)
    }
}
