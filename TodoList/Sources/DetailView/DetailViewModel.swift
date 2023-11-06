//
//  DetailViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 5/12/22.
//

import Foundation

protocol DetailViewModelProtocol: AnyObject {
    var itemDetails: Box<TodoItem>? { get set }
    func didDisappear()
}

class DetailViewModel: DetailViewModelProtocol {
    var itemDetails: Box<TodoItem>?
    var repository: RepositoryProtocol
    weak var delegate: DetailCoordinatorProtocol?
    var itemId: String?
    
    init(repository: RepositoryProtocol, itemId: String?) {
        self.repository = repository
        self.itemId = itemId
    }

    func loadItem() {
        guard let itemId = itemId,
              let item = repository.getItemBy(itemId) else {
            return
        }
        
        itemDetails = Box(.init(item))
    }
    
    func didDisappear() {
        delegate?.closeView(success: true)
    }
}
