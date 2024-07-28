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
    func displayError(msn: String)
}

class LoginCoordinator: Coordinator<Void> {
    
    private var navigationController: UINavigationController
    var viewModel: LoginViewModel?
    weak var viewController: LoginViewController?
    var repository: AuthenticationProtocol
    var keychainManager: KeychainManager

    init(navigationController: UINavigationController, 
         repository: AuthenticationProtocol,
         keychainManager: KeychainManager
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    override func start() {
        let viewModel = LoginViewModel(repository: repository, 
                                       keychainManager: keychainManager)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = LoginViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension LoginCoordinator: AuthenticationCoordinatorProtocol {
    func displayError(msn: String) {
        navigationController.displayError(msn)
    }
    
    func signUpDidTap() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            repository: repository, 
            keychainManager: keychainManager
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
