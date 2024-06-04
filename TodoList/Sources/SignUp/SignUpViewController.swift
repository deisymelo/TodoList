//
//  SignUpViewController.swift
//  TodoList
//
//  Created by Deisy Melo on 3/06/24.
//

import Foundation

import UIKit

class SignUpViewController: UIViewController {
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sign up"
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    lazy var emailTextView: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.frame.size.height = 20
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var passwordTextView: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.frame.size.height = 20
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.title = "Sign Up"
        let button = UIButton()
        button.frame.size.height = 40
        button.configuration = config
        button.addAction(
          UIAction { _ in
              self.onPressSignUpButton()
          }, for: .touchDown
        )
        return button
    }()
    
    let viewModel: SignUpViewModelProtocol
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.didDisappear()
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(emailTextView)
        contentStackView.addArrangedSubview(passwordTextView)
        contentStackView.addArrangedSubview(signUpButton)
        
        viewContent.addSubview(contentStackView)
        view.addSubview(viewContent)
        
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: viewContent.bottomAnchor)
        ])
    }
    
    @objc func onPressSignUpButton() {
        let email = emailTextView.text ?? ""
        let pass = passwordTextView.text ?? ""
        viewModel.signup(email: email, pass: pass)
    }
}
