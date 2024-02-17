//
//  CharactersListCell.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharactersListCell: View {

    private let imageURL: String
    private let name: String

    init(imageURL: String, name: String) {
        self.imageURL = imageURL
        self.name = name
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
                    .frame(width: 100.0, height: 100.0)
            }
            .clipShape(.rect(cornerRadius: 30.0))
            .aspectRatio(contentMode: .fit)
            .overlay {

//                RoundedCorner(radius: 30.0, corners: [.topLeft, .topRight])
//                    .stroke(lineWidth: 1.0)
//                    .foregroundStyle(.white.opacity(0.3))
            }
            .padding(.horizontal, 10.0)

            LinearGradient(colors: [.black, .white.opacity(0.2), .clear], startPoint: .bottom, endPoint: .center)
                .padding(.horizontal, 10.0)

            RoundedRectangle(cornerRadius: 10.0)
                .foregroundStyle(.white)
                .frame(maxHeight: 30.0)
                .overlay {
                    Text(name)
                        .fontWeight(.bold)
                }
        }
        .padding(10.0)
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
