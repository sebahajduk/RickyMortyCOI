//
//  EpisodeDetailsReducer.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EpisodeDetailsReducer {
    @ObservableState
    struct State {
        let episode: Episode
    }

    enum Action: Equatable {
        case closeButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                /// Handled by parent reducer
                return .none
            }
        }
    }
}
