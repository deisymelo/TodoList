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
    func displayError(msn: String)
}

class SignUpCoordinator: Coordinator<SignUpStatus> {
    
    private var navigationController: UINavigationController
    var viewModel: SignUpViewModel?
    weak var viewController: SignUpViewController?
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
        let viewModel = SignUpViewModel(repository: repository, 
                                        keychainManager: keychainManager)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        let viewController = SignUpViewController(viewModel: viewModel)
        self.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SignUpCoordinator: SignUpCoordinatorProtocol {
    func displayError(msn: String) {
        navigationController.displayError(msn)
    }
    
    func signUpSuccess() {
        finish(result: .success)
    }
    
    func didDisappear() {
        finish(result: .close)
    }
}
