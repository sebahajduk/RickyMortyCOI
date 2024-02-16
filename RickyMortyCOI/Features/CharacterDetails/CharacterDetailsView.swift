//
//  CharacterDetailsView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI

struct CharacterDetailsView: View {

    @State private var offset = CGSize.zero

    var body: some View {
        ZStack(alignment: .top) {
            Color.customBlack.ignoresSafeArea()

            VStack {
                Image("361")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        LinearGradient(colors: [.customBlack, .clear, .clear], startPoint: .bottom, endPoint: .top)
                    }
                
                Image("361")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .brightness(0.3)
                    .blur(radius: 50.0)
                    .mask {
                        characterDetails
                    }

                ScrollView {
                    ForEach(1..<100, id: \.self) { episode in
                        Image("361")
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
                .offset(y: -20)
            }
        }
    }

    var characterDetails: some View {
        VStack(spacing: 10.0) {
            Text("Ricky Morty".uppercased())
                .font(.system(size: 30.0, weight: .black))
            
            HStack {
                parameter(for: "Status", value: "Alive")

                parameter(for: "Gender", value: "Male")

                parameter(for: "Origin", value: "Earth")

                parameter(for: "Location", value: "Earth")
            }

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
    CharacterDetailsView()
}
