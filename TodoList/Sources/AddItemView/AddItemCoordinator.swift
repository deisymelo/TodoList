//
//  AddItemCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import UIKit

protocol AddItemCoordinatorProtocol: AnyObject {
    func closeView()
}

class AddItemCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    var viewModel: AddItemViewModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        viewModel = AddItemViewModel()
        viewModel?.delegate = self
        let viewController = AddItemViewController(viewModel: viewModel!)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AddItemCoordinator: AddItemCoordinatorProtocol {
    func closeView() {
        navigationController.popViewController(animated: true)
    }
}
