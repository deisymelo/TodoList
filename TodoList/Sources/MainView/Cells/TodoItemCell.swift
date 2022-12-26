//
//  TodoItemCellTableViewCell.swift
//  TodoList
//
//  Created by Deisy Melo on 8/11/22.
//

import UIKit

protocol TodoItemCellDelegate: AnyObject {
    func changeStatus(_ id: String)
    func selectItem(_ id: String)
}

class TodoItemCell: UITableViewCell {
    
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
        label.font = UIFont(name: "System", size: 16)
        label.text = "Title"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "System", size: 14)
        label.text = "description"
        label.textColor = .lightGray
        return label
    }()
    
    private var contentButton: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var changeStatusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        button.addTarget(self, action: #selector(changeStatus), for: .touchDown)
        return button
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(selectItem), for: .touchDown)
        return button
    }()
    
    private var itemId: String?
    weak var delegate: TodoItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
        changeStatusButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    private func setupView() {
        selectionStyle = .none
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        contentButton.addSubview(changeStatusButton)
        contentView.addSubview(contentButton)
        contentView.addSubview(contentStackView)
        contentView.addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            contentButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentButton.trailingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: -16),
            contentButton.widthAnchor.constraint(equalToConstant: 30),
            
            changeStatusButton.centerYAnchor.constraint(equalTo: contentButton.centerYAnchor),
            changeStatusButton.centerXAnchor.constraint(equalTo: contentButton.centerXAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: contentButton.trailingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            selectButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            selectButton.leadingAnchor.constraint(equalTo: contentButton.trailingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setData(_ data: TodoItem) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        itemId = data.id
        
        let imageName = data.pending ? "circle" : "circle.fill"
        changeStatusButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func selectItem() {
        guard let delegate = self.delegate,
              let id = self.itemId else {
            return
        }
        
        delegate.selectItem(id)
    }
    
    @objc func changeStatus() {
        guard let delegate = self.delegate,
              let id = self.itemId else {
            return
        }
        
        delegate.changeStatus(id)
    }
}

extension TodoItemCell {
    static let cellName: String = "TodoItemCell"
}
