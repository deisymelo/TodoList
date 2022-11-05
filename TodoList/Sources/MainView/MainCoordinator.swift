//
//  MainCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 20/10/22.
//

import UIKit

class MainCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    var viewModel: MainViewModelCoordinatorProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewModel = MainViewModel()
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension MainCoordinator: MainViewModelNavigationDelegate {

    func addNewItemTap() {
        let addItemCoordinator = AddItemCoordinator(navigationController: navigationController)
        childCoordinators.append(addItemCoordinator)
        addItemCoordinator.start()
    }
}
