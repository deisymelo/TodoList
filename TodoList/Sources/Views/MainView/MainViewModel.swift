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
    func logOut() async
}

protocol MainViewModelNavigationDelegate: AnyObject {
    func addNewItemTap()
    func showDetailBy(id: String)
    func displayError(msn: String)
    func logOutNavigation()
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
    private var repository: RepositoryProtocol
    private var userSession: UserSession
    
    init(repository: RepositoryProtocol, userSession: UserSession) {
        self.repository = repository
        self.userSession = userSession
    }
    
    func loadItems() {
        repository.getItems()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { items in
                self.itemList.value = items.map { .init($0) }
            }.store(in: &cancellables)
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
        repository.updateStatus(id)
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
    
    @MainActor
    func logOut() async {
        do {
            try await userSession.logout()
            self.repository.cleanData()
            self.delegate?.logOutNavigation()
        } catch {
            self.delegate?.displayError(msn: "log out failed")
        }
    }
}
