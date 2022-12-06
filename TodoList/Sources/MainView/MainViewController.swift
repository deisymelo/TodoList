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
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoItemCell.cellName)
        return tableView
    }()
    
    let viewModel: MainViewModelProtocol
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        setNavigationBar()
        setConstrains()
        setupBindings()
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = addItemButton
        navigationItem.title = "TODO List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setConstrains() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupBindings() {
        viewModel.itemList.bind { [weak self] list in
            guard let strongSelf = self else { return }
            
            guard !list.isEmpty else {
                //TODO: Display empty message
                return
            }
            
            strongSelf.tableView.reloadData()
        }
    }

    @objc private func tappedAddItemButton() {
        viewModel.addNewItemTap()
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: TodoItemCell.cellName, for: indexPath)
        
        guard let cell = reusableCell as? TodoItemCell,
              let item = viewModel.getItemBy(indexPath) else {
            return UITableViewCell()
        }
       
        cell.setData(item)
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
}

