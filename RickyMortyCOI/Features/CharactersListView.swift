//
//  ContentView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharactersListView: View {
    let store: StoreOf<CharactersReducer>
    
    private let gridColumns = [
        GridItem(.adaptive(minimum: 150.0, maximum: 300.0)),
        GridItem(.adaptive(minimum: 150.0, maximum: 300.0))
    ]

    var body: some View {
        ZStack {
            Color.customBlack.ignoresSafeArea()
            
            if store.showCharactersList {
                ScrollView {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(store.characters) { character in
                            CharactersListCell(image: UIImage(named: "361")!, name: character.name)
                        }
                    }
                }
                .padding()
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
        }
    }
}

#Preview {
    CharactersListView(
        store: Store(
            initialState: CharactersReducer.State()
        ){
            CharactersReducer()
        }
    )
}
