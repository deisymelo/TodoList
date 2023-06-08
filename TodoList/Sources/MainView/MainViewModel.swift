//
//  MainViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 26/10/22.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    var itemList: Box<[TodoItem]> { get set }
    var numberOfRowsInSection: Int { get }
    
    func getItemBy(_ indexPath: IndexPath) -> TodoItem?
    func addNewItemTap()
    func showDetailBy(id: String)
    func changeStatus(id: String)
}

protocol MainViewModelNavigationDelegate: AnyObject {
    func addNewItemTap()
    func showDetailBy(id: String)
    func displayError(msn: String)
}

protocol MainViewModelCoordinatorProtocol {
    var delegate: MainViewModelNavigationDelegate? { get set }
}

class MainViewModel: MainViewModelProtocol, MainViewModelCoordinatorProtocol {

    var itemList: Box<[TodoItem]> = Box([])
    private var cancellables = Set<AnyCancellable>()
    
    var numberOfRowsInSection: Int {
        itemList.value.count
    }
    
    weak var delegate: MainViewModelNavigationDelegate?
    private var coreData: CoreDataManagerProtocol
    
    init(coreData: CoreDataManagerProtocol) {
        self.coreData = coreData
    }
    
    func loadItems() {
        itemList.value = coreData.getItems().map { .init($0) }
    }
    
    func getItemBy(_ indexPath: IndexPath) -> TodoItem? {
        itemList.value[indexPath.row]
    }
    
    func addNewItemTap() {
        delegate?.addNewItemTap()
    }
    
    func showDetailBy(id: String) {
        delegate?.showDetailBy(id: id)
    }
    
    func changeStatus(id: String) {
        coreData.updateStatus(id)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    self.loadItems()
                case .failure:
                    self.delegate?.displayError(msn: "Item doesn't founded")
                }
            } receiveValue: { _ in
            }.store(in: &cancellables)
    }
}
