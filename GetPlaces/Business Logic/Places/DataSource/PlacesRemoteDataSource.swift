//
//  PlacesRemoteDataSource.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//


import Foundation

protocol PlacesRemoteDataSourceProtocol {
    func fetchPlaces(lat: String, lon: String, completion: @escaping (Result<PlacesModel, ErrorManager>) -> Void)
    func fetchPositionByCity(city: String, completion: @escaping (Result<PositionModel, ErrorManager>) -> Void)
}

class PlacesRemoteDataSource: PlacesRemoteDataSourceProtocol {
    
    private let communicationManagerProtocol: CommunicationManagerProtocol
    
    init(communicationManagerProtocol: CommunicationManagerProtocol = CommunicationManager()) {
        self.communicationManagerProtocol = communicationManagerProtocol
    }

    func fetchPlaces(lat: String, lon: String, completion: @escaping (Result<PlacesModel, ErrorManager>) -> Void) {
        communicationManagerProtocol.request(urlString: EndPoints.fetchPlaces(lat: lat, lon: lon).asRequest(), completion: { (result : Result<PlacesModel, ErrorManager>) in
            switch result {
                case .success(let model):
                completion(.success(model))
                case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func fetchPositionByCity(city: String, completion: @escaping (Result<PositionModel, ErrorManager>) -> Void) {
        communicationManagerProtocol.request(urlString: EndPoints.fetchPositionByCity(city: city).asRequest(), completion: { (result : Result<PositionModel, ErrorManager>) in
            switch result {
                case .success(let model):
                completion(.success(model))
                case .failure(let error):
                completion(.failure(error))
            }
        })
    }


}
