//
//  CircleCollectionViewCell.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 26.08.2023.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дані відсутні"
        return label
    }()
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let radius = min(bounds.width, bounds.height) / 2
        circleView.layer.cornerRadius = radius

        addSubview(circleView)
        addSubview(countLabel)
        addSubview(nameLabel)
        addSubview(differenceLabel)
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 2 * radius),
            circleView.heightAnchor.constraint(equalToConstant: 2 * radius)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            differenceLabel.topAnchor.constraint(equalTo: circleView.topAnchor, constant: -5),
            differenceLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: -12),
        ])
    }
    
    // MARK: - Configuration
    func configure(name: String, count: Int, difference: Int) {
        nameLabel.text = name
        countLabel.text = "\(count)"
        if difference < 1 {
            differenceLabel.isHidden = true
        } else {
            differenceLabel.isHidden = false
            differenceLabel.text = "+\(difference)"
        }
    }
}


