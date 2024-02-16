//
//  CharacterDetailsReducer.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterDetailsReducer {
    @ObservableState
    struct State: Equatable {
        let character: Character
    }

    enum Action { }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
