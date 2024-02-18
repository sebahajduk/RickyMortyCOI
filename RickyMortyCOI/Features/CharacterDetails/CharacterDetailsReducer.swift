//
//  CharacterDetailsReducer.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CharacterDetailsReducer {
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action.Alert>?
        var episodeDetails: EpisodeDetailsReducer.State?
        let character: Character
        var episode: Episode?
        var isFavorite: Bool
        var episodeDetailsIsPresented = false
    }

    @Dependency(\.favoriteRepository) var favoriteRepository

    enum Action {
        case episodeDetails(EpisodeDetailsReducer.Action)
        case setEpisodeDetails(isPresented: Bool)

        case episodeTapped(episode: String)
        case onSuccessEpisodeSetup(episode: Episode)

        case favoriteButtonTapped

        case errorOccured(NetworkServiceErrors)
        case alert(PresentationAction<Alert>)

        enum Alert {
            case cancelButtonTapped
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .episodeDetails(.closeButtonTapped):
                return .run { send in
                    await send(.setEpisodeDetails(isPresented: false))
                }

            case .setEpisodeDetails(isPresented: true):
                guard let episode = state.episode else { return .none }
                state.episodeDetails = EpisodeDetailsReducer.State(episode: episode)
                state.episodeDetailsIsPresented = true
                return .none

            case .setEpisodeDetails(isPresented: false):
                state.episodeDetailsIsPresented = false
                return .none

            case .episodeTapped(episode: let episode):
                return .run { send in
                    do {
                        let episode = try await NetworkService.fetchEpisodeDetails(for: episode)
                        await send(.onSuccessEpisodeSetup(episode: episode))
                    } catch {
                        if let error = error as? NetworkServiceErrors {
                            await send(.errorOccured(error))
                        }
                    }
                }

            case .onSuccessEpisodeSetup(episode: let episode):
                state.episode = episode

                return .run { send in
                    await send(.setEpisodeDetails(isPresented: true))
                }
                
            case .favoriteButtonTapped:
                let characterID = state.character.id
                state.isFavorite.toggle()

                return .run { send in
                    DispatchQueue.main.async { 
                        Task {
                            if self.favoriteRepository.favoritesList.contains(characterID) {

                                await self.favoriteRepository.removeFavorite(id: characterID)
                            } else {
                                await self.favoriteRepository.addFavorite(id: characterID)
                            }
                        }
                    }
                }

            case .errorOccured(let error):
                state.alert = AlertState {
                    TextState("Error occured!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(error.errorDescription ?? "Unknown error")
                }

                return .none
                
            case .alert(.presented(.cancelButtonTapped)):
                state.alert = nil
                return .none

            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
