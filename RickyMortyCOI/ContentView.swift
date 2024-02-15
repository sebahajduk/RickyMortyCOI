//
//  ContentView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<CharactersReducer>

    var body: some View {
        List {
            ForEach(store.characters) { character in
                Text(character.name)
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(
            initialState: CharactersReducer.State()
        ){
            CharactersReducer()
        }
    )
}
