//
//  ViewController.swift
//  TodoList
//
//  Created by Deisy Melo on 20/10/22.
//

import UIKit

class MainViewController: UIViewController {

    lazy var addItemButton: UIBarButtonItem = {
        let plusIcon = UIImage(systemName: "plus.circle")
        let button: UIBarButtonItem = UIBarButtonItem(
            image: plusIcon, style: .plain, target: self, action: #selector(tappedAddItemButton))
        button.tintColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = addItemButton
        navigationItem.title = "TODO List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func tappedAddItemButton() {
        
    }

}

