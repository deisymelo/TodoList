//
//  DetailViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 5/12/22.
//

import Foundation
import Combine

protocol DetailViewModelProtocol: AnyObject {
    var itemDetails: Box<TodoItem>? { get set }
    func didDisappear()
}

class DetailViewModel: DetailViewModelProtocol {
    var itemDetails: Box<TodoItem>?
    var repository: RepositoryProtocol
    weak var delegate: DetailCoordinatorProtocol?
    var itemId: String?
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: RepositoryProtocol, itemId: String?) {
        self.repository = repository
        self.itemId = itemId
    }

    func loadItem() {
        guard let itemId = itemId else {
            return
        }
        
        repository.getItemBy(itemId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { item in
                guard let item = item else { return }
                self.itemDetails = Box(.init(item))
            }.store(in: &cancellables)
    }
    
    func didDisappear() {
        delegate?.closeView(success: true)
    }
}
