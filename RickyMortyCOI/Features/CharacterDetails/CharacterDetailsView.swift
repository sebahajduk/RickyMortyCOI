//
//  CharacterDetailsView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {

    let store: StoreOf<CharacterDetailsReducer>

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.customBlack.ignoresSafeArea()

                VStack {
                    AsyncImage(url: URL(string: store.character.image)) { image in
                        image.resizable()
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

                    AsyncImage(url: URL(string: store.character.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .brightness(0.3)
                    .blur(radius: 50.0)
                    .mask {
                        characterDetails
                    }

                    ScrollView {
                        ForEach(1..<5, id: \.self) { episode in
                            AsyncImage(url: URL(string: store.character.image))
                                .frame(height: 30.0)
                            .brightness(0.3)
                            .blur(radius: 50.0)
                            .mask {
                                Text("Episode \(episode)".uppercased())
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 15.0, weight: .black))
                            }
                        }
                    }
                    .padding(.top, 10.0)
                }
                .ignoresSafeArea()
            }
        }
    }

    var characterDetails: some View {
        Group {
            Text(store.character.name.uppercased())
                .font(.system(size: 30.0, weight: .black))

            parameter(for: "Status", value: store.character.status)

            parameter(for: "Gender", value: store.character.gender)

            parameter(for: "Origin", value: store.character.origin.name)

            parameter(for: "Location", value: store.character.location.name)

            Text("Episodes".uppercased())
                .font(.system(size: 20.0, weight: .black))
                .padding(.top, 10.0)
        }
    }
}

extension CharacterDetailsView {
    func parameter(for name: String, value: String) -> some View {
        VStack {
            Text(value.uppercased())
                .font(.system(size: 15.0, weight: .heavy))

            Text(name.uppercased())
                .font(.system(size: 8.0))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsReducer.State(
                character: Character(
                    id: 1,
                    name: "Ricky Morty",
                    status: "Alive",
                    gender: "Male",
                    origin: LastKnownLocation(name: "Earth"),
                    location: Origin(name: "Earth"),
                    image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg"
                )
            ),
            reducer: {
                CharacterDetailsReducer()
            }
        )
    )
}
