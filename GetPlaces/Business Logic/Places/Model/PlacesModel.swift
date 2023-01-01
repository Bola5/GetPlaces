//
//  PlacesModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

struct PlacesModel: Codable {
    
    let addresses: [Addresses]
    let summary: Summary

    struct Addresses: Codable {
        
        let address: Address
        let position: String
        
        struct Address : Codable {
            
            let streetName: String
            let crossStreet: String
            let municipalitySubdivision: String
            let municipality: String
            let countrySubdivision: String
            let countryCode: String
            let country: String
            let countryCodeISO3: String
            let freeformAddress: String
            let localName: String
            let street: String
        }

    }
    
    struct Summary : Codable {
        
        let numResults: Int
        let queryTime: Int
    }
}
