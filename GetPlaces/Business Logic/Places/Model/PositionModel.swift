//
//  PositionModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 02/01/2023.
//

import Foundation

struct PositionModel: Codable {

    let results: [Results]
    
    struct Results: Codable {
        
        let position: Position
        
        struct Position: Codable {
            let lat: Double
            let lon: Double
        }
        
    }
    
}
