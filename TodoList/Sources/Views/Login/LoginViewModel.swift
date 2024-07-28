//
//  LoginViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 5/05/24.
//

import Combine
import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func login(user: String, pass: String)
    func signUpDidTap()
    func getUserCredentials(user: String) -> String?
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var delegate: AuthenticationCoordinatorProtocol?
    var repository: AuthenticationProtocol
    var keychainManager: KeychainManager
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationProtocol, keychainManager: KeychainManager) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func login(user: String, pass: String) {
        guard !user.isEmpty,
              !pass.isEmpty else {
            return
        }
        
        repository.login(email: user, pass: pass)
            .receive(on: DispatchQueue.main)
            .sink { completionState in
                if case .failure = completionState {
                    self.delegate?.displayError(msn: "Error de usuario o contraseña")
                }
            } receiveValue: { _ in
                self.storeUserInKeyChain(email: user, password: pass)
                self.delegate?.loginSuccess()
            }.store(in: &cancellables)
    }
    
    func signUpDidTap() {
        delegate?.signUpDidTap()
    }

    func getUserCredentials(user: String) -> String? {
        guard let data = keychainManager.getData(forKey: user) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func storeUserInKeyChain(email: String, password: String) {
        guard let data = password.data(using: .utf8) else { return }
        keychainManager.saveData(data, forKey: email)
    }
}
