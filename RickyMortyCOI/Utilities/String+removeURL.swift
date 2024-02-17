//
//  String+removeURL.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 17/02/2024.
//

import Foundation

extension String {
    func mapEpisodeURLToNumber() -> String {
        self.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "")
    }
}
