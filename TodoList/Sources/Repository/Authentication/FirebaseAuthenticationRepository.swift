//
//  FirebaseAuthenticationRepository.swift
//  TodoList
//
//  Created by Deisy Melo on 23/05/24.
//

import Combine
import FirebaseAuth

class FirebaseAuthenticationRepository: AuthenticationProtocol {
    func signup(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: pass) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                guard let authResult = authResult else {
                    promise(.failure(error ?? DataError.errorSignUp))
                    return
                }
                
                let user = DataUser(id: authResult.user.uid,
                                    name: authResult.user.email ?? "")
                
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, pass: String) -> AnyPublisher<DataUser?, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                if authResult != nil {
                    let user = DataUser(id: authResult?.user.uid ?? "",
                                        name: authResult?.user.displayName ?? "")
                    
                    promise(.success(user))
                } else {
                    
                    promise(.failure(error ?? DataError.errorLogin))
                }
            }
        }.eraseToAnyPublisher()
    }
}
