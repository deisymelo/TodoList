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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewModel = MainViewModel()
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        viewModel.loadItems()
    }
}

extension MainCoordinator: MainViewModelNavigationDelegate {

    func addNewItemTap() {
        let addItemCoordinator = AddItemCoordinator(navigationController: navigationController)
        addItemCoordinator.onFinish = { [weak self] result in
            if result {
                self?.viewModel?.loadItems()
            }
            self?.childCoordinators.removeLast()
        }
        childCoordinators.append(addItemCoordinator)
        addItemCoordinator.start()
    }
}
