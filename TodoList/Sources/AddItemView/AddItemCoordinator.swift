//
//  AddItemCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import UIKit

protocol AddItemCoordinatorProtocol: AnyObject {
    func closeView(success: Bool)
    func displayErrorView(message: String)
}

class AddItemCoordinator: Coordinator<Bool> {
    
    private var navigationController: UINavigationController
    var viewModel: AddItemViewModel?
    weak var viewController: AddItemViewController?
    var coreData: CoreDataManagerProtocol
    
    init(navigationController: UINavigationController, coreData: CoreDataManagerProtocol) {
        self.navigationController = navigationController
        self.coreData = coreData
    }
    
    override func start() {
        let viewModel = AddItemViewModel(coreData: coreData)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = AddItemViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AddItemCoordinator: AddItemCoordinatorProtocol {
    func displayErrorView(message: String) {
        navigationController.displayError(message)
    }
    
    func closeView(success: Bool) {
        viewController?.navigationController?.popViewController(animated: true)
        finish(result: success)
    }
}
