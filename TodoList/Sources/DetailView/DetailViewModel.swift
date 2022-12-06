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
    var index: Int?
    
    init(coreData: CoreDataManagerProtocol, index: Int?) {
        self.coreData = coreData
        self.index = index
    }

    func loadItem() {
        guard let index = index,
              let item = coreData.getItemBy(index) else {
            return
        }
        
        itemDetails = Box(item)
    }
    
    func didDisappear() {
        delegate?.closeView(success: true)
    }
}
