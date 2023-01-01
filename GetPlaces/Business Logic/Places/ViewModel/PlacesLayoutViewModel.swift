//
//  PlacesLayoutViewModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

struct PlacesLayoutViewModel {

    let addresses: [AddressesLayoutViewModel]

    init(addresses: PlacesModel) {
        self.addresses = addresses.addresses.compactMap({ AddressesLayoutViewModel(address: $0) })
    }
    
    // Addresses
    struct AddressesLayoutViewModel {
        
        let address: AddressLayoutViewModel
        let position: String
        
        init(address: PlacesModel.Addresses) {
            self.address = AddressLayoutViewModel(address: address.address)
            self.position = address.position
        }
        
        // Address
        struct AddressLayoutViewModel {
            
            let streetName: String
            let municipalitySubdivision: String
            
            init(address: PlacesModel.Addresses.Address) {
                self.municipalitySubdivision = address.municipalitySubdivision
                self.streetName = address.streetName
            }
        }
        
    }
        
    struct PlacesInfoLayoutViewModel {
        let name: String
        let streetName: String
        let lat: String
        let lon: String
    }
    
}

// MARK: - Get places info
extension PlacesLayoutViewModel {
    
    func getPlacesInfo() -> [PlacesInfoLayoutViewModel] {
        var placesInfo = [PlacesInfoLayoutViewModel]()
        for place in self.addresses {
            let postion = place.position.components(separatedBy: [","])
            placesInfo.append(PlacesInfoLayoutViewModel(name: place.address.municipalitySubdivision,
                                                        streetName: place.address.streetName,
                                                        lat: postion[0],
                                                        lon: postion[1]))
        }
        return placesInfo
    }
    
}
