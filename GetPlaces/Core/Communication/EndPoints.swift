//
//  EndPoints.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

enum EndPoints {
    
    case fetchPlaces(lat: String, lon: String)
    case fetchPositionByCity(city: String)

    private var baseURLString: String { Strings.BASE_URL }

    private var url: URL? {
        switch self {
        case .fetchPlaces(let lat, let lon):
            return URL(string: "\(baseURLString)reverseGeocode/crossStreet/\(lat),\(lon).json?limit=5&spatialKeys=true&radius=10000&allowFreeformNewLine=true&view=Unified&key=\(Strings.API_KEY)")
        case .fetchPositionByCity(let city):
            return URL(string: "\(baseURLString)geocode/\(city).json?storeResult=false&view=Unified&key=\(Strings.API_KEY)")
        }
    }

    private var parameters: [URLQueryItem] {
        switch self {
        case .fetchPlaces, .fetchPositionByCity: return []
        }
    }

    func asRequest() -> String {
        guard let url = url else {
            preconditionFailure("Missing URL for route: \(self)")
        }

        return url.description
    }
    
}
