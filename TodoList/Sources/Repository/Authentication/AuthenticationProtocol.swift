//
//  AuthenticationProtocol.swift
//  TodoList
//
//  Created by Deisy Melo on 23/05/24.
//

import Foundation
import Combine

protocol AuthenticationProtocol: AnyObject {
    func signup(email: String, pass: String) -> AnyPublisher<DataUser?, Error>
    func login(email: String, pass: String) -> AnyPublisher<DataUser?, Error>
}
