//
//  UINavigationController.swift
//  TodoList
//
//  Created by Deisy Melo on 22/02/23.
//

import UIKit

extension UINavigationController {
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        action.accessibilityIdentifier = "alertView.button.close"
        alert.addAction(action)
        present(alert, animated: true)
    }
}
