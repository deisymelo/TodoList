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
    var itemPosition: Int?
    weak var viewController: DetailViewController?
    
    init(navigationController: UINavigationController, itemPosition: Int) {
        self.navigationController = navigationController
        self.itemPosition = itemPosition
    }
    
    override func start() {
        let viewModel = DetailViewModel(coreData: CoreDataManager(), index: itemPosition)
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
