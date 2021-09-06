//
//  MiddleCollectionViewCell.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/9/21.
//

import UIKit

class MiddleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MiddleCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray5
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.sizeToFit()
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sourceLabel, titleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
        
        contentView.addSubview(stackView)
        addStackViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(with ImageUrl: String) {
        
        guard let url = URL(string: ImageUrl) else { return }
        imageView.sd_setImage(with: url)
        
    }
    
    private func addStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
}

