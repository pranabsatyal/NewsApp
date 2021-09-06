//
//  SearchResultTableViewCell.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/11/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    lazy var resultImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray5
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(resultImageView)
        contentView.addSubview(resultLabel)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addImageViewConstraints()
        addResultLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addImageViewConstraints() {
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            resultImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 100),
            resultImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    private func addResultLabelConstraints() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 10),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            resultLabel.topAnchor.constraint(equalTo: contentView.topAnchor),            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
}
