//
//  LoginCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 5/05/24.
//

import UIKit

protocol AuthenticationCoordinatorProtocol: AnyObject {
    func loginSuccess()
    func signUpDidTap()
}

class LoginCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    var viewModel: LoginViewModel?
    weak var viewController: LoginViewController?
    var repository: AuthenticationProtocol
    
    init(navigationController: UINavigationController, repository: AuthenticationProtocol) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    override func start() {
        let viewModel = LoginViewModel(repository: repository)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = LoginViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginCoordinator: AuthenticationCoordinatorProtocol {
    func signUpDidTap() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        
        signUpCoordinator.onFinish = { [weak self] status in
            switch status {
            case .close:
                self?.childCoordinators.removeLast()
            case .success:
                self?.childCoordinators.removeLast()
                self?.finish(result: ())
            }
        }

        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func loginSuccess() {
        finish(result: ())        
    }
}
