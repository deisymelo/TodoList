//
//  SignUpCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 3/06/24.
//

import UIKit

enum SignUpStatus {
    case success
    case close
}

protocol SignUpCoordinatorProtocol: AnyObject {
    func signUpSuccess()
    func didDisappear()
}

class SignUpCoordinator: Coordinator<SignUpStatus> {
    
    private var navigationController: UINavigationController
    var viewModel: SignUpViewModel?
    weak var viewController: SignUpViewController?
    var repository: AuthenticationProtocol
    
    init(navigationController: UINavigationController, repository: AuthenticationProtocol) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    override func start() {
        let viewModel = SignUpViewModel(repository: repository)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = SignUpViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SignUpCoordinator: SignUpCoordinatorProtocol {
    func signUpSuccess() {
        finish(result: .success)
    }
    
    func didDisappear() {
        finish(result: .close)
    }
}
