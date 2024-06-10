//
//  DetailCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 5/12/22.
//

import UIKit

protocol DetailCoordinatorProtocol: AnyObject {
    func closeView(success: Bool)
}

class DetailCoordinator: Coordinator<Bool> {
    
    private var navigationController: UINavigationController
    var viewModel: DetailViewModel?
    var itemId: String?
    weak var viewController: DetailViewController?
    var repository: RepositoryProtocol
    
    init(navigationController: UINavigationController,
         repository: RepositoryProtocol,
         itemId: String) {
        self.navigationController = navigationController
        self.itemId = itemId
        self.repository = repository
    }
    
    override func start() {
        let viewModel = DetailViewModel(repository: repository, itemId: itemId)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = DetailViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
        viewModel.loadItem()
    }
}

extension DetailCoordinator: DetailCoordinatorProtocol {
    func closeView(success: Bool) {
        finish(result: success)
    }
}
