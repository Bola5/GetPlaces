//
//  PlacesViewModel.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

protocol PlacesViewModelProtocol {
    
    //MARK: - Protocol - Data Source
    var places: [PlacesLayoutViewModel.PlacesInfoLayoutViewModel]? { get }
    var position: PositionsLayoutViewModel.ResultsLayoutViewModel.PositionLayoutViewModel? { get }
    
    // MARK: - Protocol - fetch
    func fetchPlaces(lat: String, lon: String, completion: @escaping PlacesViewModel.GetPlacesCompletionBlock)
    func fetchPosition(city: String, completion: @escaping PlacesViewModel.GetPositionCompletionBlock)
}

class PlacesViewModel: PlacesViewModelProtocol {

    // MARK: - Callback type alias
    typealias GetPlacesCompletionBlock = (Result<Bool, ErrorManager>) -> Void
    typealias GetPositionCompletionBlock = (Result<Bool, ErrorManager>) -> Void

    // MARK: - Properties
    // Data Source
    private let placesRemoteDataSource: PlacesRemoteDataSourceProtocol
    private var layoutViewModel: PlacesLayoutViewModel?
    private var positionLayoutViewModel: PositionsLayoutViewModel?
    
    // Init
    init(placesRemoteDataSource: PlacesRemoteDataSourceProtocol = PlacesRemoteDataSource()) {
        
        self.placesRemoteDataSource = placesRemoteDataSource
    }
    
}

// MARK: - Protocol - Data Source method
extension PlacesViewModel {
    
    var places: [PlacesLayoutViewModel.PlacesInfoLayoutViewModel]? {
        return layoutViewModel?.getPlacesInfo()
    }
    
    var position: PositionsLayoutViewModel.ResultsLayoutViewModel.PositionLayoutViewModel? {
        return positionLayoutViewModel?.results.first?.position
    }
    
}

// MARK: - Protocol - fetch
extension PlacesViewModel {
    
    func fetchPlaces(lat: String, lon: String, completion: @escaping GetPlacesCompletionBlock) {
        placesRemoteDataSource.fetchPlaces(lat: lat, lon: lon, completion: { [weak self] (result: Result<PlacesModel, ErrorManager>) in
            switch result {
            case .success(let placesModel):
                self?.layoutViewModel = PlacesLayoutViewModel(addresses: placesModel)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(.parser(string: error.localizedDescription)))
            }
        })
        
    }
    
    func fetchPosition(city: String, completion: @escaping GetPositionCompletionBlock) {
        placesRemoteDataSource.fetchPositionByCity(city: city, completion: { [weak self] (result: Result<PositionModel, ErrorManager>) in
            switch result {
            case .success(let positionsModel):
                self?.positionLayoutViewModel = PositionsLayoutViewModel(positions: positionsModel)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(.parser(string: error.localizedDescription)))
            }
        })

    }
    
}
