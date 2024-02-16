//
//  EpisodeDetailsView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {

    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .background(.ultraThinMaterial)
                .onTapGesture {
                    withAnimation {
                        isPresented.toggle()
                    }
                }

            VStack(spacing: 10.0) {
                ParameterView(parameterName: "Episode name", parameterValue: "Anatomy Park")

                ParameterView(parameterName: "Episode", parameterValue: "S01E03")

                ParameterView(parameterName: "Air date", parameterValue: "December 16, 2013")

                ParameterView(parameterName: "Characters", parameterValue: "21")
            }
            .padding()
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        isPresented.toggle()
                    }
                } label: {
                    Text("X")
                }
                .foregroundStyle(.red)
                .padding(10.0)
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
