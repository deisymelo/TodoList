//
//  AddItemViewController.swift
//  TodoList
//
//  Created by Deisy Melo on 3/11/22.
//

import UIKit

class AddItemViewController: UIViewController {
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.frame.size.height = 20
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.height = 20
        textField.placeholder = "Description"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.title = "Save item"
        let button = UIButton()
        button.frame.size.height = 40
        button.configuration = config
        button.addAction(
          UIAction { _ in
              self.saveItem()
          }, for: .touchDown
        )
        return button
    }()
    
    let viewModel: AddItemViewModelProtocol
    
    init(viewModel: AddItemViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setupView()
    }
    
    func setNavigationBar() {
        navigationItem.title = "Add item"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(descriptionTextField)
        contentStackView.addArrangedSubview(addButton)
        
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
    
    private func saveItem() {
        viewModel.addNewItemTap(item: TodoItem(title: "test", description: "test"))
    }
}
