//
//  PlacesViewModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

protocol PlacesViewModelProtocol {
    
    // MARK: - Protocol - fetch
    func fetchPlaces(lat: String, lon: String, completion: @escaping PlacesViewModel.GetPlacesCompletionBlock)
}

class PlacesViewModel: PlacesViewModelProtocol {

    // MARK: - Callback type alias
    typealias GetPlacesCompletionBlock = (Result<Bool, ErrorManager>) -> Void

    // MARK: - Properties
    // Data Source
    private let placesRemoteDataSource: PlacesRemoteDataSourceProtocol
    private var layoutViewModel: PlacesLayoutViewModel?
    
    // Init
    init(placesRemoteDataSource: PlacesRemoteDataSourceProtocol = PlacesRemoteDataSource()) {
        
        self.placesRemoteDataSource = placesRemoteDataSource
    }
    
}

// MARK: - Protocol - fetch
extension PlacesViewModel {
    
    func fetchPlaces(lat: String, lon: String, completion: @escaping GetPlacesCompletionBlock) {
        placesRemoteDataSource.fetchPlaces(lat: lat, lon: lon, completion: { [weak self] (result: Result<PlacesModel, ErrorManager>) in
            switch result {
            case .success(let placesModel):
                print(placesModel)
                self?.layoutViewModel = PlacesLayoutViewModel(addresses: placesModel)
                print(self?.layoutViewModel)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(.parser(string: error.localizedDescription)))
            }
        })
        
    }
    
}
