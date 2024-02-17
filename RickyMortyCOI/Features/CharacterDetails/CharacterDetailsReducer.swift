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
    struct State {
        var episodeDetails: EpisodeDetailsReducer.State?
        let character: Character
        var episode: Episode?

        var episodeDetailsIsPresented = false
    }

    enum Action {
        case episodeDetails(EpisodeDetailsReducer.Action)
        case setEpisodeDetails(isPresented: Bool)

        case episodeTapped(episode: String)
        case onSuccessEpisodeSetup(episode: Episode)
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
                    let episode = try await NetworkService.fetchEpisodeDetails(for: episode)
                    await send(.onSuccessEpisodeSetup(episode: episode))
                }

            case .onSuccessEpisodeSetup(episode: let episode):
                state.episode = episode

                return .run { send in
                    await send(.setEpisodeDetails(isPresented: true))
                }
            }
        }
    }
}
