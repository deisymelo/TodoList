//
//  SignUpViewModel.swift
//  TodoList
//
//  Created by Deisy Melo on 3/06/24.
//

import Combine
import Foundation

protocol SignUpViewModelProtocol: AnyObject {
    func signup(email: String, pass: String)
    func didDisappear()
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    weak var delegate: SignUpCoordinatorProtocol?
    var repository: AuthenticationProtocol
    var keychainManager: KeychainManager
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationProtocol, keychainManager: KeychainManager) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func signup(email: String, pass: String) {
        guard !email.isEmpty,
              !pass.isEmpty else {
            return
        }
        
        repository.signup(email: email, pass: pass)
            .receive(on: DispatchQueue.main)
            .sink { completionState in
                if case .failure = completionState {
                    self.delegate?.displayError(msn: "Sign up error")
                }
            } receiveValue: { _ in
                self.storeUserInKeyChain(email: email, password: pass)
                self.delegate?.signUpSuccess()
            }.store(in: &cancellables)
    }
    
    func didDisappear() {
        delegate?.didDisappear()
    }
    
    func storeUserInKeyChain(email: String, password: String) {
        guard let data = password.data(using: .utf8) else { return }
        keychainManager.saveData(data, forKey: email)
    }
    
    func validateBio() {
        // Mostrar un alert "Desea FaceId..."
        // Llamar localAutentication
        // Guardar user y pass en el keyChain
        
    }
}
