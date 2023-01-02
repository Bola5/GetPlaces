//
//  GetPlacesTests.swift
//  GetPlacesTests
//
//  Created by Bola Fayez on 02/01/2023.
//

import XCTest
@testable import GetPlaces

final class GetPlacesTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: PlacesViewModel!
    private var dataSource: PlacesRemoteDataSource!
    
    // MARK: - tearDown
    override func tearDown() {
        
        viewModel = nil
        dataSource = nil
        
        super.tearDown()
    }
    
    // MARK: - testRetrivedRemoteDataPlaces
    func testRetrivedRemoteDataPlaces() {
        
        let mockData = PlacesModel.parse(jsonFile: "places")
        let getPlacesAPI = GetPlacesAPITests(data: mockData)
        dataSource = PlacesRemoteDataSource(communicationManagerProtocol: getPlacesAPI)
        
        dataSource.fetchPlaces(lat: "37.7873589", lon: "-122.408227", completion: { result in
            switch result {
            case .success(let placesModel):
                XCTAssertNotNil(placesModel.addresses)
                XCTAssertTrue(placesModel.addresses.count > 0)
            case .failure(let error):
                XCTAssertNotNil(error.getStringError())
            }
        })
        
    }
    
    
    // MARK: - testFetchPlaces
    func testFetchPlaces() {
                
        viewModel = PlacesViewModel(placesRemoteDataSource: MockRemoteDataSourceGetPlaces())
        
        viewModel.fetchPlaces(lat: "37.7873589", lon: "-122.408227", completion: { [weak self] result in
            switch result {
                
            case .success:
                
                XCTAssertEqual(self?.viewModel.places?.count, 2)
                
                if let firstPlace = self?.viewModel.places?.first {
                    XCTAssertEqual(firstPlace.name, "Geary Street")
                    XCTAssertEqual(firstPlace.streetName, "Powell Street & Geary Street")
                    XCTAssertEqual(firstPlace.lon, "-122.40825")
                    XCTAssertEqual(firstPlace.lat, "37.78737")
                } else {
                    XCTFail("This should not happen.")
                }
                
                if let lastPlace = self?.viewModel.places?.last {
                    XCTAssertEqual(lastPlace.name, "Sutter Street")
                    XCTAssertEqual(lastPlace.streetName, "Sutter Street & Powell Street")
                    XCTAssertEqual(lastPlace.lon, "-122.40857")
                    XCTAssertEqual(lastPlace.lat, "37.78925")
                } else {
                    XCTFail("This should not happen.")
                }
                
            case .failure:
                XCTFail("This should not happen.")
            }
        })
        
    }
    
    // MARK: - testFetchPositions
    func testFetchPositions() {
                
        viewModel = PlacesViewModel(placesRemoteDataSource: MockRemoteDataSourceGetPlaces())
        
        viewModel.fetchPosition(city: "london", completion: { [weak self] result in
            switch result {
                
            case .success:
                
                XCTAssertNotNil(self?.viewModel.position)
                
                if let position = self?.viewModel.position {
                    XCTAssertEqual(position.lat, 30.1111)
                    XCTAssertEqual(position.lon, 31.111)
                } else {
                    XCTFail("This should not happen.")
                }
                
            case .failure:
                XCTFail("This should not happen.")
            }
        })
        
    }
    
}

// MARK: - Mocks
extension GetPlacesTests {
    
    // MARK: - MockRemoteDataSourceGetPlaces
    struct MockRemoteDataSourceGetPlaces: PlacesRemoteDataSourceProtocol {
        
        
        private let placeModel = PlacesModel(addresses: [ PlacesModel.Addresses(address:
                                                                                    PlacesModel.Addresses.Address(streetName: "Powell Street & Geary Street",
                                                                                                                  crossStreet: "Geary Street",
                                                                                                                  municipalitySubdivision: "Downtown San Francisco",
                                                                                                                  municipality: "San Francisco",
                                                                                                                  countrySubdivision: "San Francisco",
                                                                                                                  countryCode: "CA",
                                                                                                                  country: "California",
                                                                                                                  countryCodeISO3: "94102",
                                                                                                                  freeformAddress: "Powell Street & Geary Street, San Francisco, CA 94102",
                                                                                                                  localName: "San Francisco",
                                                                                                                  street: "Powell Street"),
                                                                                position: "37.78737,-122.40825"),
                                                          PlacesModel.Addresses(address:
                                                                                    PlacesModel.Addresses.Address(streetName: "Sutter Street & Powell Street",
                                                                                                                  crossStreet: "Sutter Street",
                                                                                                                  municipalitySubdivision: "Downtown San Francisco",
                                                                                                                  municipality: "San Francisco",
                                                                                                                  countrySubdivision: "San Francisco",
                                                                                                                  countryCode: "CA",
                                                                                                                  country: "California",
                                                                                                                  countryCodeISO3: "94102",
                                                                                                                  freeformAddress: "Powell Street & Geary Street, San Francisco, CA 94102",
                                                                                                                  localName: "San Francisco",
                                                                                                                  street: "Powell Street"),
                                                                                position: "37.78925,-122.40857")],
                                             summary: PlacesModel.Summary(numResults: 5, queryTime: 125))
        
        
        private let positionsModel = PositionModel(results: [ PositionModel.Results(position: PositionModel.Results.Position(lat: 30.1111, lon: 31.111)),
                                                              PositionModel.Results(position: PositionModel.Results.Position(lat: 32.1111, lon: 34.11111))])
        
        func fetchPlaces(lat: String, lon: String, completion: @escaping (Result<GetPlaces.PlacesModel, GetPlaces.ErrorManager>) -> Void) {
            completion(.success(placeModel))
        }
        
        func fetchPositionByCity(city: String, completion: @escaping (Result<GetPlaces.PositionModel, GetPlaces.ErrorManager>) -> Void) {
            completion(.success(positionsModel))
        }
        
    }
    
}
