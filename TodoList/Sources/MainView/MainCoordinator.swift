//
//  MainCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 20/10/22.
//

import UIKit

class MainCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    weak var viewModel: MainViewModel?
    var coreData: DataSourceProtocol = LocalDataSource()
    var repository: RepositoryProtocol
    
    init(navigationController: UINavigationController, repository: RepositoryProtocol) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    override func start() {
        let viewModel: MainViewModel
        viewModel = MainViewModel(repository: repository)
        
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        viewModel.loadItems()
    }
}

extension MainCoordinator: MainViewModelNavigationDelegate {

    func addNewItemTap() {
        let addItemCoordinator = AddItemCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        
        addItemCoordinator.onFinish = { [weak self] result in
            if result {
                self?.viewModel?.loadItems()
            }
            self?.childCoordinators.removeLast()
        }
        childCoordinators.append(addItemCoordinator)
        addItemCoordinator.start()
    }
    
    func showDetailBy(id: String) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            repository: repository,
            itemId: id
        )
        
        detailCoordinator.onFinish = { [weak self] _ in
            self?.childCoordinators.removeLast()
        }
        
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func displayError(msn: String) {
        navigationController.displayError(msn)
    }
}
