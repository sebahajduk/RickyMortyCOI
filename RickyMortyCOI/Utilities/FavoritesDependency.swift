//
//  FavoritesDependency.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 18/02/2024.
//

import Foundation
import ComposableArchitecture

private enum FavoritesDependency {
    static let live = FavoritesRepository()
}

extension FavoritesDependency: DependencyKey {
    static let liveValue = FavoritesDependency.live
}

extension DependencyValues {
    var favoriteRepository: FavoritesRepository {
        get { self[FavoritesDependency.self] }
        set { self[FavoritesDependency.self] = newValue }
    }
}
