//
//  CharactersListCell.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharactersListCell: View {

    let imageURL: String
    let name: String
    let isFavorite: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                case .failure:
                    tryAgain()
                default:
                    Color.red
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(.rect(cornerRadius: 30.0))
            .aspectRatio(contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 30.0)
                    .stroke(lineWidth: 1.0)
                    .foregroundStyle(.white.opacity(0.3))
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
                        .foregroundStyle(Color.customBlack)
                }
        }
        .overlay(alignment: .topTrailing) {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
                    .foregroundStyle(Color.red)
                    .padding(10.0)
                    .background(Color.customBlack.clipShape(Circle()))
                    .offset(x: 10.0, y: -10.0)
            }
        }
        .padding(10.0)
    }

    func tryAgain() -> some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
            case .failure:
                Color.red
            default:
                Color.red
            }
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
