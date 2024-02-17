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
        
        var episodeDetailsIsPresented = false
    }

    enum Action {
        case episodeDetails(EpisodeDetailsReducer.Action)
        case setEpisodeDetails(isPresented: Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setEpisodeDetails(isPresented: true):
                state.episodeDetails = EpisodeDetailsReducer.State()
                state.episodeDetailsIsPresented = true

                return .none
            case .setEpisodeDetails(isPresented: false):
                state.episodeDetailsIsPresented = false

                return .none
            case .episodeDetails(.closeButtonTapped):

                return .run { send in
                    await send(.setEpisodeDetails(isPresented: false))
                }
            }
        }
        .ifLet(\.episodeDetails, action: \.episodeDetails) {
            EpisodeDetailsReducer()
        }
    }
}
