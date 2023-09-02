//
//  ViewController.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 23.08.2023.
//

import UIKit
import FSCalendar
import SafariServices

class ViewController: UIViewController {
    
    // MARK: - Properties
    var selectedDate: Date?
    var selectedDateString: String?
    var previusSelectedDateString: String?
    var availableDates: [String] = []
    var russiaLossesEquipment: [RussiaLossesEquipment] = []
    var russiaLossesPersonnel: [RussiaLossesPersonnel] = []
    
    // MARK: - UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let gloryToUkraineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("🇷🇺 🔫 🇺🇦", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let airAlarmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("🚨 Повітряна тривога", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let donateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("🫶🏼 Допомога армії", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dayWarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lossesOccupiersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calendarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = true
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.appearance.titleWeekendColor = .red
        calendar.select(Date())
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.accessibilityIdentifier = "calendar"
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CircleCollectionViewCell.self, forCellWithReuseIdentifier: "CircleCollectionViewCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        loadAndSetupData()
        setupUI()
    }
    
    // MARK: - SetUp Methods
    func setupUI() {
        setUpButtons()
        setupNavigationBar()
        setupBackgroundGradient()
        setupInitialDates()
        setupLabel()
        setupConstraints()
        setupSwipeGestureRecognizer()
    }
    
    private func setupSwipeGestureRecognizer() {
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(addButtonTapped))
        swipeRightGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    private func loadAndSetupData() {
        activityIndicator.startAnimating()
        
        let dataDispatchGroup = DispatchGroup()
        
        dataDispatchGroup.enter()
        loadEquipmentData(group: dataDispatchGroup)
        
        dataDispatchGroup.enter()
        loadPersonnelData(group: dataDispatchGroup)
        
        dataDispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
            self.setupInitialDates()
            self.setupLabel()
            self.activityIndicator.stopAnimating()
        }
    }

    private func setupLabel() {
        let attributedText = generateAttributedHeaderText()
        gloryToUkraineLabel.attributedText = attributedText
        
        if let formattedDate = formattedSelectedDate() {
            lossesOccupiersLabel.text = "Втрати окупантів\nНа \(formattedDate)"
        } else {
            lossesOccupiersLabel.text = "Втрати окупантів\nНа невідома дата"
        }
    }
    
    private func setupInitialDates() {
        if let lastEquipmentDateString = russiaLossesEquipment.last?.date {
            selectedDateString = lastEquipmentDateString
            setupPreviousDateSelection()
            setupDayWarLabel()
        }
    }
    
    private func setupDayWarLabel() {
        if let lastEquipmentDayString = russiaLossesEquipment.last?.day {
            dayWarLabel.text = "\(lastEquipmentDayString) день війни"
        }
    }
    
    private func setupPreviousDateSelection() {
        if let lastEquipmentDateString = russiaLossesEquipment.last?.date,
           let lastEquipmentDate = DateFormatter.yyyyMMdd.date(from: lastEquipmentDateString),
           let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: lastEquipmentDate) {
            previusSelectedDateString = DateFormatter.yyyyMMdd.string(from: previousDate)
            calendar.select(lastEquipmentDate)
        }
    }
    
    private func generateAttributedHeaderText() -> NSAttributedString {
        let attributesBlue = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        let attributesYellow = [
            NSAttributedString.Key.foregroundColor: UIColor.systemYellow,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        
        let attributedText = NSMutableAttributedString(string: "Слава ", attributes: attributesBlue)
        attributedText.append(NSAttributedString(string: "Україні 🇺🇦", attributes: attributesYellow))
        
        return attributedText
    }
    
    private func setupNavigationBar() {
        let customBarButtonItem = UIBarButtonItem(customView: barButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
        barButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setUpButtons() {
        airAlarmButton.addTarget(self, action: #selector(openAirAlarm), for: .touchUpInside)
        donateButton.addTarget(self, action: #selector(openDonate), for: .touchUpInside)

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
        view.addSubview(activityIndicator)
        view.addSubview(calendarContainerView)
        view.addSubview(calendar)
        view.addSubview(gloryToUkraineLabel)
        view.addSubview(dayWarLabel)
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        view.addSubview(lossesOccupiersLabel)
        
        buttonStackView.addArrangedSubview(airAlarmButton)
        buttonStackView.addArrangedSubview(donateButton)
        
        NSLayoutConstraint.activate([
            calendarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
        ])
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            gloryToUkraineLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            gloryToUkraineLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            gloryToUkraineLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: calendarContainerView.topAnchor, constant: -5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 140),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: gloryToUkraineLabel.bottomAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        NSLayoutConstraint.activate([
            lossesOccupiersLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor,constant: 20),
            lossesOccupiersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            lossesOccupiersLabel.heightAnchor.constraint(equalToConstant: 100),
            lossesOccupiersLabel.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            dayWarLabel.topAnchor.constraint(equalTo: lossesOccupiersLabel.bottomAnchor, constant: -30),
            dayWarLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            dayWarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dayWarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: dayWarLabel.bottomAnchor, constant: 30),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Methods
    private func formattedSelectedDate() -> String? {
        if let selectedDate = selectedDateString.flatMap({ DateFormatter.yyyyMMdd.date(from: $0) }) {
            return DateFormatter.ddMMyyyy.string(from: selectedDate)
        }
        return nil
    }
    
    private func getSelectedLossesAndEquipment(dateString: String) -> RussiaLossesEquipment? {
        return russiaLossesEquipment.first(where: { $0.date == dateString })
        
    }
    
    private func getSelectedPersonal(dateString: String) -> RussiaLossesPersonnel? {
        return russiaLossesPersonnel.first(where: { $0.date == dateString })
    }
    
    private func calculateDifference(_ newValue: Int, _ previousValue: Int) -> Int {
        return newValue - previousValue
    }
    
    private func updateLossesOccupiersLabel() {
        if let selectedDateStr = selectedDateString,
           let selectedDate = DateFormatter.yyyyMMdd.date(from: selectedDateStr) {
            let formattedDate = DateFormatter.ddMMyyyy.string(from: selectedDate)
            lossesOccupiersLabel.text = "Втрати окупантів\nНа \(formattedDate)"
        } else {
            lossesOccupiersLabel.text = "Втрати окупантів\nНа невідому дату"
        }
    }
    
    private func updateDayWarLabel() {
        guard let selectedDate = selectedDateString else { return }
        if let selectedLossesAndEquipment = getSelectedLossesAndEquipment(dateString: selectedDate) {
            let description = "день війни"
            animateNumberChange(to: selectedLossesAndEquipment.day, label: dayWarLabel, description: description)
        } else {
            dayWarLabel.text = "День війни не відомий"
        }
    }
    
    private func pushToDetailsViewController(_ selectedLossesAndEquipment: RussiaLossesEquipment,
                                            _ selectedPersonal: RussiaLossesPersonnel?,
                                            _ previousLossesAndEquipment: RussiaLossesEquipment?,
                                            _ previousPersonal: RussiaLossesPersonnel?,
                                            _ date: Date) {
        
        let detailsViewController = DetailsViewController()
        
        detailsViewController.lossesAndEquipment = selectedLossesAndEquipment
        detailsViewController.lossesPersonal = selectedPersonal
        detailsViewController.previousLossesAndEquipment = previousLossesAndEquipment
        detailsViewController.previousPersonal = previousPersonal
        detailsViewController.date = DateFormatter.ddMMyyyy.string(from: date)
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    // MARK: - Actions
    private func animateNumberChange(to newValue: Int, label: UILabel, description: String) {
        UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: {
            label.text = "\(newValue) \(description)"
        }, completion: nil)
    }
    
    @objc func addButtonTapped() {
        guard let selectedDateString = selectedDateString,
              let selectedDate = DateFormatter.yyyyMMdd.date(from: selectedDateString) else { return }
        
        guard let selectedLossesAndEquipment = getSelectedLossesAndEquipment(dateString: selectedDateString) else { return }
        let selectedPersonal = getSelectedPersonal(dateString: selectedDateString)
        
        guard let previousDateString = previusSelectedDateString else { return }
        let previousLossesAndEquipment = getSelectedLossesAndEquipment(dateString: previousDateString)
        let previousPersonal = getSelectedPersonal(dateString: previousDateString)
        
        pushToDetailsViewController(selectedLossesAndEquipment,
                                   selectedPersonal,
                                   previousLossesAndEquipment,
                                   previousPersonal,
                                   selectedDate)
    }
    
    @objc func openAirAlarm() {
        if let url = URL(string: "https://alerts.in.ua") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc func openDonate() {
        if let url = URL(string: "https://uahelp.monobank.ua") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Load Data
    private func loadEquipmentData(group: DispatchGroup) {
        DispatchQueue.global().async {
            NetworkManager.shared.fetchDataEquipment { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let russiaLossesEquipment):
                        self.russiaLossesEquipment = russiaLossesEquipment
                        let dates = russiaLossesEquipment.compactMap { $0.date }
                        self.availableDates = dates
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
        }
    }
    
    private func loadPersonnelData(group: DispatchGroup) {
        DispatchQueue.global().async {
            NetworkManager.shared.fetchDataPersonnel { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let russiaLossesPersonnel):
                        self.russiaLossesPersonnel = russiaLossesPersonnel
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
        }
    }
}
// MARK: - Extensions FSCalendar
extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter.yyyyMMdd
        selectedDate = date
        selectedDateString = dateFormatter.string(from: date)
        
        if let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date) {
            previusSelectedDateString = dateFormatter.string(from: previousDate)
        } else {
            previusSelectedDateString = nil
        }
        
        updateDayWarLabel()
        updateLossesOccupiersLabel()
        collectionView.reloadData()
    }
}

extension ViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at monthPosition: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: monthPosition)
        
        let dateString = DateFormatter.yyyyMMdd.string(from: date)
        if availableDates.contains(dateString) {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        return cell
    }
}

// MARK: - Extensions CollectionView
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath) as! CircleCollectionViewCell
        
        if let selectedDate = selectedDateString,
           let previusSelectedDate = previusSelectedDateString {
            
            guard let personal = getSelectedPersonal(dateString: selectedDate),
                  let equipment = getSelectedLossesAndEquipment(dateString: selectedDate),
                  let previusPersonal = getSelectedPersonal(dateString: previusSelectedDate),
                  let previusEquipment = getSelectedLossesAndEquipment(dateString: previusSelectedDate) else {
                cell.configure(name: "Невідомо", count: 0, difference: 0)
                return cell
            }
            
            let differencePersonnel = calculateDifference(personal.personnel, previusPersonal.personnel)
            
            switch indexPath.row {
            case 0:
                cell.configure(name: "Окупантів",
                               count: personal.personnel,
                               difference: differencePersonnel)
            case 1:
                cell.configure(name: "Танків",
                               count: equipment.tank,
                               difference: calculateDifference(equipment.tank, previusEquipment.tank))
            case 2:
                cell.configure(name: "БПЛА",
                               count: equipment.drone,
                               difference: calculateDifference(equipment.drone, previusEquipment.drone))
            case 3:
                cell.configure(name: "Ракет",
                               count: equipment.cruiseMissiles ?? 0,
                               difference: calculateDifference(equipment.cruiseMissiles ?? 0, previusEquipment.cruiseMissiles ?? 0))
            default:
                break
            }
        } else {
            cell.configure(name: "Невідомо", count: 0, difference: 0)
        }
        
        return cell
    }
}

// MARK: - Extensions UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let itemWidth = screenWidth / 5
        return CGSize(width: itemWidth, height: 100)
    }
}

// MARK: - Extensions DateFormatter
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
