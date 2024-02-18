//
//  FavoritesDependency.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 18/02/2024.
//

import Foundation
import ComposableArchitecture

private enum FavoritesDependency: DependencyKey {
    static let liveValue = FavoritesRepository()
}

extension DependencyValues {
    var favoriteRepository: FavoritesRepository {
        get { self[FavoritesDependency.self] }
        set { self[FavoritesDependency.self] = newValue }
    }
}
