//
//  NetworkServiceErrors.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import Foundation

enum NetworkServiceErrors: Error {
    case wrongURL, invalidResponse, invalidData
}

extension NetworkServiceErrors: LocalizedError {
    var localizedDescription: String? {
        switch self {
        case .wrongURL:
            "Wrong URL. Cannot download data."
        case .invalidResponse:
            "Invalid response, check your internet connection."
        case .invalidData:
            "Data is invalid, try again."
        }
    }
}
