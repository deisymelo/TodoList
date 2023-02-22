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
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
