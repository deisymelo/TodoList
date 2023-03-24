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
        
        #if DEBUG
        button.accessibilityIdentifier = "mainViewController.button.addItem"
        #endif
        
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
        tableView.accessibilityIdentifier = "mainViewController.table"
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
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = addItemButton
        navigationItem.title = "TODO List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupBindings() {
        viewModel.itemList.bind { [weak self] list in
            guard let strongSelf = self else { return }
            
            if list.count == 0 {
                strongSelf.tableView.setEmptyMessage("There aren't elements")
            } else {
                strongSelf.tableView.restore()
            }
            
            strongSelf.tableView.reloadData()
        }
    }

    @objc private func tappedAddItemButton() {
        viewModel.addNewItemTap()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        cell.accessibilityIdentifier = TodoItemCell.cellName + "\(indexPath.row)"
        cell.setData(item)
        cell.delegate = self
        return cell
    }
    
}

extension MainViewController: TodoItemCellDelegate {
    func changeStatus(_ id: String) {
        viewModel.changeStatus(id: id)
    }
    
    func selectItem(_ id: String) {
        viewModel.showDetailBy(id: id)
    }
}

#if DEBUG
extension MainViewController {
    var testHooks: TestHooks {
        return TestHooks(target: self)
    }

    struct TestHooks {
        private let target: MainViewController

        fileprivate init(target: MainViewController) {
            self.target = target
        }

        var numberOfRowsInSection: Int {
            target.viewModel.numberOfRowsInSection
        }
        
        func tappedAddItemButton() {
            target.tappedAddItemButton()
        }
        
        func changeStatus(_ id: String) {
            target.changeStatus(id)
        }
        
        func selectItem(_ id: String) {
            target.selectItem(id)
        }
    }
}
#endif

