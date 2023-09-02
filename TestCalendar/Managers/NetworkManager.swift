//
//  NetworkManager.swift
//  TestCalendar
//
//  Created by Zabroda Gleb on 02.09.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchDataEquipment(completion: @escaping (Result<[RussiaLossesEquipment], Error>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/PetroIvaniuk/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_equipment.json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(url).responseDecodable(of: [RussiaLossesEquipment].self) { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDataPersonnel(completion: @escaping (Result<[RussiaLossesPersonnel], Error>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/PetroIvaniuk/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_personnel.json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(url).responseDecodable(of: [RussiaLossesPersonnel].self) { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}

