//
//  FirebaseAuthenticationRepository.swift
//  TodoList
//
//  Created by Deisy Melo on 23/05/24.
//

import Combine
import FirebaseAuth

class FirebaseAuthenticationRepository: AuthenticationProtocol, UserSession {
    
    func logout() async throws {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func getCurrentUser() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func signup(email: String, pass: String) -> AnyPublisher<DataUser, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
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
    
    func login(email: String, pass: String) -> AnyPublisher<DataUser, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: pass) { authResult, error in
                if authResult != nil {
                    let user = DataUser(id: authResult?.user.uid ?? "",
                                        name: authResult?.user.displayName ?? "")
                    
                    promise(.success(user))
                } else {
                    
                    promise(.failure(DataError.errorLogin))
                }
            }
        }.eraseToAnyPublisher()
    }
}
