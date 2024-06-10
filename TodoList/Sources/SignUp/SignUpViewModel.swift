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
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationProtocol) {
        self.repository = repository
    }
    
    func signup(email: String, pass: String) {
        guard !email.isEmpty,
              !pass.isEmpty else {
            return
        }
        
        repository.signup(email: email, pass: pass)
            .receive(on: DispatchQueue.main)
            .sink { completionState in
                if case .failure(let error) = completionState {
                    self.delegate?.displayError(msn: error.localizedDescription)
                }
            } receiveValue: { user in
                self.delegate?.signUpSuccess()
            }.store(in: &cancellables)
    }
    
    func didDisappear() {
        delegate?.didDisappear()
    }
    
    func storeUserInKeyChain() {
        // Guardar la info en el keyChain
    }
    
    func validateBio() {
        // Mostrar un alert "Desea FaceId..."
        // Llamar localAutentication
        // Guardar user y pass en el keyChain
        
    }
    
    func getUserCredentials() {
        // auto fill del formulario
    }
}
