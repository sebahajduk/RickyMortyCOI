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
        @Presents var alert: AlertState<Action.Alert>?
        var favoritesID = Set<Int>()
        var characters: IdentifiedArrayOf<Character> = []
        var showCharactersList = false
        var page = 1
    }

    @Dependency(\.favoriteRepository) var favoriteRepository

    enum Action {
        case alert(PresentationAction<Alert>)
        case showListButtonTapped
        case charactersResponse([Character])
        case reachedBottomOnList
        case updateData
        case errorOccured(Error)

        enum Alert {
            case cancelButtonTapped
        }
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
                        do {
                            let charactersList = try await NetworkService.fetchCharactersList(for: 1)
                            await send(.charactersResponse(charactersList))
                        } catch {
                            await send(.errorOccured(error))
                        }
                    }
                } else {
                    state.characters = []
                    return .none
                }
            case .charactersResponse(let response):
                response.forEach { state.characters.append($0) }
                state.favoritesID = self.favoriteRepository.favoritesList
                return .none

            case .reachedBottomOnList:
                let nextPage = state.page + 1
                state.page = nextPage
                return .run { send in
                    do {
                        
                        let charactersList = try await NetworkService.fetchCharactersList(for: nextPage)

                        await send(.charactersResponse(charactersList))
                    } catch {
                        await send(.errorOccured(error))
                    }
                }

            case .updateData:
                state.favoritesID = self.favoriteRepository.favoritesList
                return .none

            case .alert(.presented(.cancelButtonTapped)):
                state.alert = nil
                return .none
            
            case .alert:
                return .none

            case .errorOccured(let error):
                state.alert = AlertState {
                    TextState("Error occured")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(error.localizedDescription)
                }

                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
