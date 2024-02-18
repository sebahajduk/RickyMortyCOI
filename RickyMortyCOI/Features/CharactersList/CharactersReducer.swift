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
        var characterDetails: CharacterDetailsReducer.State?
        @Presents var alert: AlertState<Action.Alert>?
        var favoritesID = Set<Int>()
        var characters: IdentifiedArrayOf<Character> = []
        var showCharactersList = false
        var page = 1

        var searchText = ""
    }

    @Dependency(\.favoriteRepository) var favoriteRepository

    enum Action {
        case alert(PresentationAction<Alert>)
        case showListButtonTapped
        case charactersResponse([Character])
        case reachedBottomOnList
        case updateData
        case errorOccured(NetworkServiceErrors)
        case searchChanged(String)
        case searchChangeDebounced

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
                            if let error = error as? NetworkServiceErrors {
                                await send(.errorOccured(error))
                            }
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
                        if let error = error as? NetworkServiceErrors {
                            await send(.errorOccured(error))
                        }
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
                    TextState(error.errorDescription ?? "Unknown error")
                }

                return .none
            case .searchChanged(let text):
                state.searchText = text
                return .none

            case .searchChangeDebounced:
                let searchText = state.searchText
                state.characters.removeAll()
                return .run { send in
                    do {
                        var charactersList = [Character]()
                        
                        if !searchText.isEmpty {
                            charactersList = try await NetworkService.fetchCharactersList(for: 1, filter: searchText)
                        } else {
                            charactersList = try await NetworkService.fetchCharactersList(for: 1)
                        }
                        await send(.charactersResponse(charactersList))
                    } catch {
                        if let error = error as? NetworkServiceErrors {
                            await send(.errorOccured(error))
                        }
                    }
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
