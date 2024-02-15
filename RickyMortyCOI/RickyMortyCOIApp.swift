//
//  RickyMortyCOIApp.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickyMortyCOIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: CharactersReducer.State()
                ) {
                    CharactersReducer()
                }
            )
        }
    }
}
