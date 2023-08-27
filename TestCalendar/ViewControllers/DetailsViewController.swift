//
//  SecondViewController.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 23.08.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Properties
    var lossesAndEquipment: RussiaLossesEquipment?
    var lossesPersonal: RussiaLossesPersonnel?
    var previousLossesAndEquipment: RussiaLossesEquipment?
    var previousPersonal: RussiaLossesPersonnel?
    var date: String?
    var equipmentData: [EquipmentData] = []
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "zsuLOGO")
        return imageView
    }()
    
    private let lossesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Орієнтовні втрати противника"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let dayWarLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Втрати ворога"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LossesSmallCollectionViewCell.self,
                                forCellWithReuseIdentifier: "LossesSmallCollectionViewCell")
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1.0)
        setupBackgroundGradient()
        setupConstraints()
        setupData()
        setupDateLabel()
        setupDayWarLabel()
    }

    // MARK: - SetUp Methods
    private func setupDateLabel() {
        let boldFont = UIFont.boldSystemFont(ofSize: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.black
        ]
        
        let dateString = "24.02.2022"
        let attributedText = NSMutableAttributedString(string: dateString, attributes: nil)
        
        if let date = date {
            let dateAttributedString = NSAttributedString(string: " - \(date)", attributes: attributes)
            attributedText.append(dateAttributedString)
        } else {
            let placeholderAttributedString = NSAttributedString(string: " - Дані відсутні", attributes: attributes)
            attributedText.append(placeholderAttributedString)
        }
        
        dateLabel.attributedText = attributedText
    }
    
    private func setupDayWarLabel() {
        dayWarLabel.text = "День війни: \(lossesAndEquipment?.day ?? 0)"
    }
    
    
    private func setupBackgroundGradient() {
        let lightBlue = UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1.0)
        let white = UIColor.white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [lightBlue.cgColor, white.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(imageView)
        view.addSubview(lossesLabel)
        view.addSubview(dateLabel)
        view.addSubview(dayWarLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width / 3), // Ширина экрана на треть
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            lossesLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            lossesLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            lossesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            dayWarLabel.topAnchor.constraint(equalTo: lossesLabel.bottomAnchor, constant: 15),
            dayWarLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: dayWarLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
        ])
    }
    
    // MARK: - Methods
    private func calculateDifference(_ newValue: Int, _ previousValue: Int) -> Int {
        return newValue - previousValue
    }
}
    
    // MARK: - Extensions UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equipmentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LossesSmallCollectionViewCell", for: indexPath) as! LossesSmallCollectionViewCell
        let data = equipmentData[indexPath.row]
        let countDifference = calculateDifference(data.currentCount, data.previousCount)
        cell.configure(title: "\(data.title)", currentCount: data.currentCount, countDifference: countDifference)
        return cell
    }
}

    // MARK: - Extensions UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: 80)
        } else {
            let width = (collectionView.frame.width - 20) / 2
            return CGSize(width: width, height: 70)
        }
    }
}

    // MARK: - Extensions DetailsViewController
extension DetailsViewController {
    private func setupData() {
        equipmentData = [
            EquipmentData(title: "Ліквідовано особового складу",
                          currentCount: lossesPersonal?.personnel ?? 0,
                          previousCount: previousPersonal?.personnel ?? 0),
            EquipmentData(title: "Танків",
                          currentCount: lossesAndEquipment?.tank ?? 0,
                          previousCount: previousLossesAndEquipment?.tank ?? 0),
            EquipmentData(title: "ББМ",
                          currentCount: lossesAndEquipment?.apc ?? 0,
                          previousCount: previousLossesAndEquipment?.apc ?? 0),
            EquipmentData(title: "Арт.систем",
                          currentCount: lossesAndEquipment?.fieldArtillery ?? 0,
                          previousCount: previousLossesAndEquipment?.fieldArtillery ?? 0),
            EquipmentData(title: "РСЗВ",
                          currentCount: lossesAndEquipment?.mrl ?? 0,
                          previousCount: previousLossesAndEquipment?.mrl ?? 0),
            EquipmentData(title: "Засобів ППО",
                          currentCount: lossesAndEquipment?.antiAircraftWarfare ?? 0,
                          previousCount: previousLossesAndEquipment?.antiAircraftWarfare ?? 0),
            EquipmentData(title: "Літаків",
                          currentCount: lossesAndEquipment?.aircraft ?? 0,
                          previousCount: previousLossesAndEquipment?.aircraft ?? 0),
            EquipmentData(title: "Гелікоптерів",
                          currentCount: lossesAndEquipment?.helicopter ?? 0,
                          previousCount: previousLossesAndEquipment?.helicopter ?? 0),
            EquipmentData(title: "Автоцистерн",
                          currentCount: lossesAndEquipment?.vehiclesAndFuelTanks ?? 0,
                          previousCount: previousLossesAndEquipment?.vehiclesAndFuelTanks ?? 0),
            EquipmentData(title: "Кораблів/катерів",
                          currentCount: lossesAndEquipment?.navalShip ?? 0,
                          previousCount: previousLossesAndEquipment?.navalShip ?? 0),
            EquipmentData(title: "Крилатих ракет",
                          currentCount: lossesAndEquipment?.cruiseMissiles ?? 0,
                          previousCount: previousLossesAndEquipment?.cruiseMissiles ?? 0),
            EquipmentData(title: "БПЛА",
                          currentCount: lossesAndEquipment?.drone ?? 0,
                          previousCount: previousLossesAndEquipment?.drone ?? 0),
            EquipmentData(title: "Спец.техніки",
                          currentCount: lossesAndEquipment?.specialEquipment ?? 0,
                          previousCount: previousLossesAndEquipment?.specialEquipment ?? 0),
        ]
    }
}
    



