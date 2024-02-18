//
//  EpisodeDetailsView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {

    var store: StoreOf<EpisodeDetailsReducer>

    var body: some View {
        ZStack {
            Color.customBlack.opacity(0.3)
                .background(.ultraThinMaterial)
                .onTapGesture {
                    store.send(.closeButtonTapped)
                }

            VStack(spacing: 10.0) {
                ParameterView(parameterName: "Episode name", parameterValue: store.episode.name)

                ParameterView(parameterName: "Episode", parameterValue: store.episode.episode)

                ParameterView(parameterName: "Air date", parameterValue: store.episode.airDate)

                ParameterView(parameterName: "Characters", parameterValue: "\(store.episode.characters.count)")
            }
            .padding()
            .overlay(alignment: .topTrailing) {
                Button {
                    store.send(.closeButtonTapped)
                } label: {
                    Text("X")
                        .padding(5.0)
                        .background(Color.red.opacity(0.3))
                        .clipShape(Circle())
                }
                .foregroundStyle(.red)
                .padding(10.0)
                .padding(.trailing, 5.0)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke()
            }
            .background(Color.customBlack.clipShape(.rect(cornerRadius: 10.0)))
            .padding()
            .foregroundStyle(.white)
        }
    }
}
