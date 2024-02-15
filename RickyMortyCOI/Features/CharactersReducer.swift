//
//  CharactersReducer.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CharactersReducer {
    @ObservableState
    struct State: Equatable {
        var characters: IdentifiedArrayOf<Character> = []
        var showCharactersList = false

        init() {
            let lastKnownLocation1 = LastKnownLocation(name: "Earth (C-137)")
            let origin1 = Origin(name: "Earth (C-137)")
            let character1 = Character(id: 1, name: "Rick Sanchez", status: "Alive", gender: "Male", origin: lastKnownLocation1, location: origin1, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")

            let lastKnownLocation2 = LastKnownLocation(name: "Abadango")
            let origin2 = Origin(name: "unknown")
            let character2 = Character(id: 2, name: "Morty Smith", status: "Alive", gender: "Male", origin: lastKnownLocation2, location: origin2, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")

            let lastKnownLocation3 = LastKnownLocation(name: "Earth (Replacement Dimension)")
            let origin3 = Origin(name: "Earth (Replacement Dimension)")
            let character3 = Character(id: 3, name: "Summer Smith", status: "Alive", gender: "Female", origin: lastKnownLocation3, location: origin3, image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")

            let lastKnownLocation4 = LastKnownLocation(name: "Earth (C-137)")
            let origin4 = Origin(name: "Earth (C-137)")
            let character4 = Character(id: 4, name: "Jerry Smith", status: "Alive", gender: "Male", origin: lastKnownLocation4, location: origin4, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg")

            let lastKnownLocation5 = LastKnownLocation(name: "Earth (C-137)")
            let origin5 = Origin(name: "Earth (C-137)")
            let character5 = Character(id: 5, name: "Beth Smith", status: "Alive", gender: "Female", origin: lastKnownLocation5, location: origin5, image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")

            characters = [character1, character2, character3, character4, character5]
        }
    }
    
    enum Action {
        case showListButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showListButtonTapped:
                withAnimation {
                    state.showCharactersList.toggle()
                }

                return .none
            }
        }
    }
}
