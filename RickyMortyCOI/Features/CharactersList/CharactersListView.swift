//
//  ContentView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharactersListView: View {
    @Perception.Bindable var store: StoreOf<CharactersReducer>

    private let gridColumns = [
        GridItem(.adaptive(minimum: 150.0, maximum: 300.0)),
        GridItem(.adaptive(minimum: 150.0, maximum: 300.0))
    ]

    var body: some View {
        NavigationView {
            WithPerceptionTracking {
                ZStack {
                    Color.customBlack.ignoresSafeArea()
                        .onAppear {
                            store.send(.updateData)
                        }

                    if store.showCharactersList {
                        VStack {
                            TextField("Search", text: $store.searchText.sending(\.searchChanged))
                                .textFieldStyle(.roundedBorder)
                                .padding()

                            ScrollView {
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(store.characters) { character in
                                        WithPerceptionTracking {
                                            NavigationLink {
                                                CharacterDetailsView(
                                                    store: Store(
                                                        initialState: CharacterDetailsReducer.State(
                                                            character: character,
                                                            isFavorite: store.favoritesID.contains(character.id)
                                                        ),
                                                        reducer: {
                                                            CharacterDetailsReducer()
                                                        }
                                                    )
                                                )
                                            } label: {
                                                CharactersListCell(
                                                    imageURL: character.image,
                                                    name: character.name,
                                                    isFavorite: store.favoritesID.contains(character.id)
                                                )
                                                .onAppear {
                                                    if character == store.state.characters.last {
                                                        store.send(.reachedBottomOnList)
                                                    }
                                                }
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .task(id: store.searchText) {
                                do {
                                    if #available(iOS 16.0, *) {
                                        try await Task.sleep(for: .seconds(0.3))
                                    } else {
                                        try await Task.sleep(nanoseconds: 300_000_000)
                                    }
                                    await store.send(.searchChangeDebounced).finish()
                                } catch { }
                            }
                        }
                    } else {
                        Text("Tap eye button to show Rick and Morty characters")
                            .font(.headline)
                            .padding()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        store.send(.showListButtonTapped)
                    } label: {
                        Circle()
                            .frame(width: 60.0, height: 60.0)
                            .foregroundStyle(.white)
                            .overlay {
                                Image(systemName: store.showCharactersList ? "eye.slash" : "eye")
                                    .foregroundStyle(Color.customBlack)
                                    .font(.title2)
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(44.0)
                    .alert($store.scope(state: \.alert, action: \.alert))
                }
            }
        }
    }
}

#Preview {
    CharactersListView(
        store: Store(
            initialState: CharactersReducer.State()
        ) {
            CharactersReducer()
        }
    )
}
