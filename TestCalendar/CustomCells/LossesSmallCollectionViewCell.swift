//
//  LossesSmallCollectionViewCell.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 25.08.2023.
//

import UIKit

class LossesSmallCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        layer.cornerRadius = 16
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.masksToBounds = true
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(differenceLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            differenceLabel.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: 13),
            differenceLabel.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, currentCount: Int, countDifference: Int) {
        titleLabel.text = title
        countLabel.text = "\(currentCount)"
        
        if countDifference < 1 {
            differenceLabel.isHidden = true
        } else {
            differenceLabel.text = "+\(countDifference)"
        }
        
    }
}

