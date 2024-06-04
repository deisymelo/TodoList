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
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var delegate: AuthenticationCoordinatorProtocol?
    var repository: AuthenticationProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationProtocol) {
        self.repository = repository
    }
    
    func login(user: String, pass: String) {
        guard !user.isEmpty,
              !pass.isEmpty else {
            return
        }
        
        repository.login(email: user, pass: pass)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { user in
                // guardar userID
                //Si hay un error mostrarlo en pantalla
                //storeUserInKeyChain()
                self.delegate?.loginSuccess()
            }.store(in: &cancellables)
    }
    
    func signUpDidTap() {
        delegate?.signUpDidTap()
    }
}
