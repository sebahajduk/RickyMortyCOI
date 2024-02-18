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

    static func fetchCharactersList(for page: Int, filter: String? = nil) async throws -> [Character] {
        var stringForURL = ""
        
        if let filter {
            stringForURL = "https://rickandmortyapi.com/api/character?page=\(page)&name=\(filter)"
        } else {
            stringForURL = "https://rickandmortyapi.com/api/character?page=\(page)"
        }

        guard
            let url = URL(string: stringForURL)
        else {
            throw NetworkServiceErrors.wrongURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            if filter != nil {
                return []
            } else {
                throw NetworkServiceErrors.invalidResponse
            }
        }
        
        do {
            let decoder = JSONDecoder()
            
            let rickyMortyResponse = try decoder.decode(RickyMortyResponse.self, from: data)

            return rickyMortyResponse.results
        } catch {
            throw NetworkServiceErrors.invalidData
        }
    }

    static func fetchEpisodeDetails(for episodeURL: String) async throws -> Episode {
        guard
            let url = URL(string: episodeURL)
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
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let episode = try decoder.decode(Episode.self, from: data)

            return episode
        } catch {
            throw NetworkServiceErrors.invalidData
        }
    }
}
