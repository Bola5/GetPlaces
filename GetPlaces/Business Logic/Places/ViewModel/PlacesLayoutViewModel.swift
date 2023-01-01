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
        
        init(address: PlacesModel.Addresses) {
            self.address = AddressLayoutViewModel(address: address.address)
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
    
}
