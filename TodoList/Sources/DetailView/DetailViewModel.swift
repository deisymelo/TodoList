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
    var coreData: CoreDataManagerProtocol
    weak var delegate: DetailCoordinatorProtocol?
    var itemId: String?
    
    init(coreData: CoreDataManagerProtocol, itemId: String?) {
        self.coreData = coreData
        self.itemId = itemId
    }

    func loadItem() {
        guard let itemId = itemId,
              let item = coreData.getItemBy(itemId) else {
            return
        }
        
        itemDetails = Box(.init(item))
    }
    
    func didDisappear() {
        delegate?.closeView(success: true)
    }
}
