//
//  FavoritesRepository.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 18/02/2024.
//

import Foundation
import RealmSwift
import ComposableArchitecture

class Favorites: Object {
    @Persisted var list: MutableSet<Int>
}

final class FavoritesRepository: ObservableObject {
    private var realm: Realm!
    private var favorites: Favorites?
    private let realmQueue = DispatchQueue.main

    @Published private(set) var favoritesList = Set<Int>()

    init() {
        realm = try? Realm()
        
        if realm.objects(Favorites.self).isEmpty {
            try? realm?.write {
                realm?.add(Favorites())
            }
        } else {
            favorites = realm.objects(Favorites.self).first
            favorites?.list.forEach { characterID in
                favoritesList.insert(characterID)
            }
        }
    }
}

extension FavoritesRepository {
    func addFavorite(id: Int) async {
        favoritesList.insert(id)
        await save()
    }

    func removeFavorite(id: Int) async {
        favoritesList.remove(id)

        await save()
    }
}

private extension FavoritesRepository {
    func save() async {
        try? await realm.asyncWrite {
            self.favorites?.list.removeAll()
            self.favorites?.list.insert(objectsIn: self.favoritesList)
        }
    }
}
