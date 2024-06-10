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
    let navigationController = UINavigationController()
    var repository: RepositoryProtocol
    private let userSession: UserSession = FirebaseAuthenticationRepository()
    
    init(window: UIWindow) {
        self.window = window
        
        if CommandLine.arguments.contains("UITests") {
            repository = DataManagerMock()
        } else {
            repository = DataSourceRepository(
                localDataSource: LocalDataSource(),
                remoteDataSource: RemoteDataSource(), 
                userSession: userSession
            )
        }
    }
    
    override func start() {
        if userSession.getCurrentUser() != nil {
            openHomePage()
        } else {
            openAutenticationPage()
        }
    }
    
    func openAutenticationPage() {
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            repository: FirebaseAuthenticationRepository()
        )
        
        childCoordinators.append(coordinator)
        coordinator.start()
        
        coordinator.onFinish = { [weak self] _ in
            guard let self = self else { return }
            self.openHomePage()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openHomePage() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            repository: repository, 
            userSession: userSession
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        mainCoordinator.onFinish = { [weak self] _ in
            guard let self = self else { return }
            self.openAutenticationPage()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
