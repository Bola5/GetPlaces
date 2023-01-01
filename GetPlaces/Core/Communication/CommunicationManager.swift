//
//  CommunicationManager.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

protocol CommunicationManagerProtocol {
    func request<T: Codable>(urlString: String, completion: @escaping (Result<T, ErrorManager>) -> Void)
}

class CommunicationManager: CommunicationManagerProtocol {

    func request<T: Codable>(urlString: String, completion: @escaping (Result<T, ErrorManager>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.parser(string: error.localizedDescription))); return
            }
            if let data = data {
                do {
                    let data = try CodableManager.decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(.parser(string: error.localizedDescription)))
                }
            }
        }.resume()
    }
    
}
