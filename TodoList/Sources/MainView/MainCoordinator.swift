//
//  MainCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 20/10/22.
//

import UIKit
import DataManager

class MainCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    weak var viewModel: MainViewModel?
    var coreData: CoreDataManagerProtocol
    
    init(navigationController: UINavigationController, coreData: CoreDataManagerProtocol) {
        self.navigationController = navigationController
        self.coreData = coreData
    }
    
    override func start() {
        let viewModel: MainViewModel
        viewModel = MainViewModel(coreData: coreData)
        
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
            coreData: coreData
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
            coreData: coreData,
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
