//
//  EndPoints.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

enum EndPoints {
    
    case fetchDogBreedsList
    case fetchDogBreedImages(breedName: String)

    private var baseURLString: String { "https://dog.ceo/api/" }

    private var url: URL? {
        switch self {
        case .fetchDogBreedsList:
            return URL(string: baseURLString + "breeds/list/all")
        case .fetchDogBreedImages(let breedName):
            return URL(string: "\(baseURLString)breed/\(breedName)/images")
        }
    }

    private var parameters: [URLQueryItem] {
        switch self {
        case .fetchDogBreedsList, .fetchDogBreedImages: return []
        }
    }

    func asRequest() -> String {
        guard let url = url else {
            preconditionFailure("Missing URL for route: \(self)")
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters

        guard let parametrizedURL = components?.url else {
            preconditionFailure("Missing URL with parameters for url: \(url)")
        }

        return parametrizedURL.absoluteString
    }
    
}
