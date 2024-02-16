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
    struct State {
        @Presents var characterDetails: CharacterDetailsReducer.State?

        var characters: IdentifiedArrayOf<Character> = []
        var showCharactersList = false
        var page = 1

    }

    enum Action {
        case showListButtonTapped
        case charactersResponse([Character])
        case reachedBottomOnList
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showListButtonTapped:
                withAnimation {
                    state.showCharactersList.toggle()
                }
                
                if state.showCharactersList {
                    state.page = 1
                    
                    return .run { send in
                        let charactersList = try await NetworkService.fetchCharactersList(for: 1)
                        
                        await send(.charactersResponse(charactersList))
                    }
                } else {
                    state.characters = []
                    return .none
                }
            case .charactersResponse(let response):
                response.forEach { state.characters.append($0) }
                
                return .none
            case .reachedBottomOnList:
                let nextPage = state.page + 1
                state.page = nextPage
                
                return .run { send in
                    let charactersList = try await NetworkService.fetchCharactersList(for: nextPage)
                    
                    await send(.charactersResponse(charactersList))
                }
            }
        }
    }
}
