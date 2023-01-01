//
//  ErrorManager.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import Foundation

enum ErrorManager: Error {
    
    case parser(string: String?)
    
    func getStringError() -> String? {
        switch self {
        case .parser(let string):
            return(string)
        }
    }
}
