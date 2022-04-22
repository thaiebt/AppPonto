//
//  ReceiptTableViewCell.swift
//  alura-ponto
//
//  Created by c94289a on 22/02/22.
//

import UIKit

protocol ReceiptTableViewCellDelegate: NSObject {
    func deleteReceipt(index: Int)
}

class ReceiptTableViewCell: UITableViewCell {
    
    lazy var backgroundViewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 253/255, green: 241/255, blue: 208/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()

    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    lazy var statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var statusTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "STATUS: "
        label.textColor = .systemGreen
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SINCRONIZADA"
        label.textColor = .systemGreen
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var registerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "REGISTRO DE PONTO DO TRABALHADOR"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "23/02/2022 09:09"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(deleteReceipt), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: ReceiptTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(receipt: Receipt) {
        statusLabel.text = receipt.status == true ? "SINCRONIZADO" : "NÃO SINCRONIZADO"
        statusLabel.textColor = receipt.status == true ? .systemGreen : .systemRed
        
        let dateFormatter = DateAndTimeFormatter()
        dateLabel.text = dateFormatter.getDate(receipt.date)
    }
    
    @objc func deleteReceipt(sender: UIButton) {
        delegate?.deleteReceipt(index: sender.tag)
    }
    
    func setupCell() {
        contentView.addSubview(backgroundViewCell)
        backgroundViewCell.addSubview(stackView)
        stackView.addArrangedSubview(statusView)
        statusView.addSubview(statusTitleLabel)
        statusView.addSubview(statusLabel)
        contentView.addSubview(deleteButton)
        stackView.addArrangedSubview(registerTitleLabel)
        stackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundViewCell.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundViewCell.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: backgroundViewCell.topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: backgroundViewCell.leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: backgroundViewCell.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: backgroundViewCell.bottomAnchor, constant: -10),
            
            statusTitleLabel.leftAnchor.constraint(equalTo: statusView.leftAnchor),
            statusTitleLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            
            statusLabel.leftAnchor.constraint(equalTo: statusTitleLabel.rightAnchor, constant: 3),
            statusView.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: 3),
            statusLabel.centerYAnchor.constraint(equalTo: statusTitleLabel.centerYAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 15),
            deleteButton.widthAnchor.constraint(equalToConstant: 15),
            deleteButton.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
        ])
    }
}
