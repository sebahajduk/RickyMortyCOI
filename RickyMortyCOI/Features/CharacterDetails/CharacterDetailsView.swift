//
//  CharacterDetailsView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    @Perception.Bindable var store: StoreOf<CharacterDetailsReducer>
    @State private var image: Image?

    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                ZStack(alignment: .top) {
                    Color.customBlack.ignoresSafeArea()
                    
                    VStack(spacing: 10.0) {
                        AsyncImage(url: URL(string: store.character.image)) { image in
                            image
                                .resizable()
                                .onAppear {
                                    self.image = image
                                }
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fill)
                        .overlay {
                            LinearGradient(
                                colors: [
                                    .customBlack,
                                    .clear,
                                    .clear
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        }

                        if let image {
                            image
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .brightness(0.3)
                                .blur(radius: 50.0)
                                .mask {
                                    characterDetails
                                }

                            ScrollView {
                                ForEach(store.character.episode, id: \.self) { episodeURL in
                                    image
                                        .frame(height: 30.0)
                                        .brightness(0.3)
                                        .blur(radius: 50.0)
                                        .mask {
                                            Text("Episode \(episodeURL.mapEpisodeURLToNumber())".uppercased())
                                                .frame(maxWidth: .infinity)
                                                .font(.system(size: 15.0, weight: .black))
                                        }
                                        .onTapGesture {
                                            var transaction = Transaction()
                                            transaction.disablesAnimations = true

                                            store.send(.episodeTapped(episode: episodeURL))
                                        }
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $store.episodeDetailsIsPresented.sending(\.setEpisodeDetails)) {
                    if let store = store.scope(state: \.episodeDetails, action: \.episodeDetails) {
                        EpisodeDetailsView(
                            store: store
                        )
                        .background(ClearBackground())
                        .ignoresSafeArea()
                    }
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.favoriteButtonTapped)
                    } label: {
                        Image(systemName: store.isFavorite ? "heart.fill" : "heart")
                            .font(.headline)
                            .padding(10.0)
                            .background(Color.customBlack)
                            .clipShape(.rect(cornerRadius: 10.0))
                    }
                    .foregroundStyle(Color.red)
                }
            }
            .navigationBarBackButtonHidden(store.episodeDetailsIsPresented)
        }
    }

    var characterDetails: some View {
        Group {
            Text(store.character.name.uppercased())
                .font(.system(size: 30.0, weight: .black))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .inset(by: -5.0)
                        .stroke()
                }

            ParameterView(parameterName: "Status", parameterValue: store.character.status)
                .padding(.top, 5.0)
            ParameterView(parameterName: "Gender", parameterValue: store.character.gender)

            ParameterView(parameterName: "Origin", parameterValue: store.character.origin.name)

            ParameterView(parameterName: "Location", parameterValue: store.character.location.name)

            Rectangle()
                .frame(height: 1)
                .padding(.vertical, 10.0)

            Text("Episodes".uppercased())
                .font(.system(size: 20.0, weight: .black))
        }
        .padding(.horizontal)
    }
}

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsReducer.State(character: Character(
                    id: 1,
                    name: "Ricky Morty",
                    status: "Alive",
                    gender: "Male",
                    origin: Origin(name: "Earth"),
                    location: LastKnownLocation(name: "Earth"),
                    image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
                    episode: []
            ), isFavorite: false
            ),
            reducer: {
                CharacterDetailsReducer()
            }
        )
    )
}
