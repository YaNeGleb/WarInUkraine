//
//  Model.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 24.08.2023.
//

import Foundation


struct RussiaLossesEquipment: Codable {
    let date: String
    let day, aircraft, helicopter, tank: Int
    let apc, fieldArtillery, mrl: Int
    let militaryAuto, fuelTank: Int?
    let drone, navalShip, antiAircraftWarfare: Int
    let specialEquipment, mobileSRBMSystem: Int?
    let greatestLossesDirection: String?
    let vehiclesAndFuelTanks, cruiseMissiles: Int?

    enum CodingKeys: String, CodingKey {
        case date, day, aircraft, helicopter, tank
        case apc = "APC"
        case fieldArtillery = "field artillery"
        case mrl = "MRL"
        case militaryAuto = "military auto"
        case fuelTank = "fuel tank"
        case drone
        case navalShip = "naval ship"
        case antiAircraftWarfare = "anti-aircraft warfare"
        case specialEquipment = "special equipment"
        case mobileSRBMSystem = "mobile SRBM system"
        case greatestLossesDirection = "greatest losses direction"
        case vehiclesAndFuelTanks = "vehicles and fuel tanks"
        case cruiseMissiles = "cruise missiles"
    }
}


struct RussiaLossesPersonnel: Codable {
    let date: String
    let personnel: Int
}

struct EquipmentData {
    var title: String
    var currentCount: Int
    var previousCount: Int
}



