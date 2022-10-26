//
//  Coordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 20/10/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
