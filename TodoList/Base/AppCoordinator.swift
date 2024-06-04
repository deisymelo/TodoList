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
    
    init(window: UIWindow) {
        self.window = window
        
        if CommandLine.arguments.contains("UITests") {
            repository = DataManagerMock()
        } else {
            repository = DataSourceRepository(
                localDataSource: LocalDataSource(),
                remoteDataSource: RemoteDataSource()
            )
        }
        
    }
    
    override func start() {
        //Validar si la sesion está abierta
        
        var coordintor: Coordinator<Void>
        
        coordintor = LoginCoordinator(
            navigationController: navigationController,
            repository: FirebaseAuthenticationRepository()
        )
        childCoordinators.append(coordintor)
        coordintor.start()
        
        coordintor.onFinish = { [weak self] _ in
            guard let self = self else { return }
            
            self.openHomePage()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openHomePage() {
        navigationController.dismiss(animated: false)
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        UIWindow(frame: UIScreen.main.bounds).rootViewController = navigationController
        UIWindow(frame: UIScreen.main.bounds).makeKeyAndVisible()
    }
}
