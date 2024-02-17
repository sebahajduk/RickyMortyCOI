//
//  NetworkService.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import Foundation

struct NetworkService {
    struct RickyMortyResponse: Codable {
        let results: [Character]
    }

    static func fetchCharactersList(for page: Int) async throws -> [Character] {
        guard
            let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)")
        else {
            throw NetworkServiceErrors.wrongURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw NetworkServiceErrors.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            
            let results = try decoder.decode(RickyMortyResponse.self, from: data)

            return results.results
        } catch {
            throw NetworkServiceErrors.invalidData
        }
    }
}
