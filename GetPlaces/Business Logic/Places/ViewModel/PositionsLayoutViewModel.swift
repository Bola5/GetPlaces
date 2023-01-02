//
//  PositionsLayoutViewModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 02/01/2023.
//

import Foundation

struct PositionsLayoutViewModel {

    let results: [ResultsLayoutViewModel]
    
    init(positions: PositionModel) {
        self.results = positions.results.compactMap({ ResultsLayoutViewModel(position: $0) })
    }
    
    struct ResultsLayoutViewModel {
        
        let position: PositionLayoutViewModel
        
        init(position: PositionModel.Results) {
            self.position = PositionLayoutViewModel(position: position.position)
        }
        
        struct PositionLayoutViewModel {
            
            let lat: Double
            let lon: Double
            
            init(position: PositionModel.Results.Position) {
                self.lon = position.lon
                self.lat = position.lat
            }
            
        }
        
    }

}
