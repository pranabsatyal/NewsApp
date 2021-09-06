//
//  HeaderCollectionReusableView.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/10/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let monthsNames = [
        "1": "January",
        "2": "February",
        "3": "March",
        "4": "April",
        "5": "May",
        "6": "June",
        "7": "July",
        "8": "August",
        "9": "September",
        "10": "October",
        "11": "November",
        "12": "December"
    ]
    
    lazy var headerLabel1: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.textColor = .systemGray2
        return label
    }()
    
    lazy var headerLabel2: UILabel = {
        let label = UILabel()
        label.text = "Top Stories"
        label.font = .systemFont(ofSize: 35, weight: .heavy)
        label.textColor = .systemPink
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerLabel1, headerLabel2])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        
        let date = Date()
        let calender = Calendar.current
        let month = calender.component(.month, from: date)
        let day = calender.component(.day, from: date)
        
        headerLabel1.text = "\(monthsNames["\(month)"]!) \(day)"
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
