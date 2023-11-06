//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Deisy Melo on 21/10/22.
//

import Foundation
import UIKit

class Coordinator<T> {

    var childCoordinators: [Any] = []
    var onFinish: ((T) -> Void)?
    
    func start() {}
    
    // Informa que el coordinator finalizó
    func finish(result: T) {
        onFinish?(result)
    }
}

final class AppCoordinator: Coordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        var repository: RepositoryProtocol
        
        if CommandLine.arguments.contains("UITests") {
            repository = DataManagerMock()
        } else {
            repository = DataSourceRepository(
                localDataSource: LocalDataSource(),
                remoteDataSource: LocalDataSource()
            )
        }
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
