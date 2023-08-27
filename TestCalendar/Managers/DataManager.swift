//
//  DataManager.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 24.08.2023.
//


import Foundation

struct DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func loadAvailableDatesFromJSON() -> [String] {
        var availableDates: [String] = []
        
        if let url = Bundle.main.url(forResource: "russia_losses_equipment", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let dataModels = try JSONDecoder().decode([RussiaLossesEquipment].self, from: data)
                availableDates = dataModels.map { $0.date}
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return availableDates
    }
    
    func loadFromJSON() -> [RussiaLossesEquipment] {
        var availableDates: [RussiaLossesEquipment] = []
        
        if let url = Bundle.main.url(forResource: "russia_losses_equipment", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                availableDates = try JSONDecoder().decode([RussiaLossesEquipment].self, from: data)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return availableDates
    }
    
    func loadPersonalFromJSON() -> [RussiaLossesPersonnel] {
        var availablePersonal: [RussiaLossesPersonnel] = []
        
        if let url = Bundle.main.url(forResource: "russia_losses_personnel", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                availablePersonal = try JSONDecoder().decode([RussiaLossesPersonnel].self, from: data)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return availablePersonal
    }
}





