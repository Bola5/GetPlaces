//
//  PlacesRemoteDataSource.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//


import Foundation

protocol PlacesRemoteDataSourceSourceProtocol {
    
}

class PlacesRemoteDataSource: PlacesRemoteDataSourceSourceProtocol {
    
    private let communicationManagerProtocol: CommunicationManagerProtocol
    
    init(communicationManagerProtocol: CommunicationManagerProtocol = CommunicationManager()) {
        self.communicationManagerProtocol = communicationManagerProtocol
    }

    
    
}
