//
//  DetailViewController.swift
//  TodoList
//
//  Created by Deisy Melo on 5/12/22.
//

import UIKit

class DetailViewController: UIViewController {
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.frame.size.height = 20
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.frame.size.height = 20
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.frame.size.height = 20
        return label
    }()
    
    let viewModel: DetailViewModelProtocol
    
    init(viewModel: DetailViewModelProtocol) {
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
        setupBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.didDisappear()
    }
    
    func setNavigationBar() {
        navigationItem.title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(statusLabel)
        
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
    
    func setupBindings() {
        viewModel.itemDetails?.bind { [weak self] item in
            guard let strongSelf = self else { return }
            
            strongSelf.titleLabel.text = item.title
            strongSelf.descriptionLabel.text = item.description
            strongSelf.statusLabel.text = item.pending ? "Pending" : "Finished"
        }
    }
}
