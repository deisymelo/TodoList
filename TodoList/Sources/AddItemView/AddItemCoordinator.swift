//
//  AddItemCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import UIKit

protocol AddItemCoordinatorProtocol: AnyObject {
    func closeView(success: Bool)
}

class AddItemCoordinator: Coordinator<Bool> {
    
    private var navigationController: UINavigationController
    var viewModel: AddItemViewModel?
    weak var viewController: AddItemViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewModel = AddItemViewModel(coreData: CoreDataManager())
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = AddItemViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AddItemCoordinator: AddItemCoordinatorProtocol {
    func closeView(success: Bool) {
        viewController?.navigationController?.popViewController(animated: true)
        finish(result: success)
    }
}
