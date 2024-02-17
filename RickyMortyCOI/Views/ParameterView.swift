//
//  ParameterView.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import SwiftUI

struct ParameterView: View {
    let parameterName: String
    let parameterValue: String

    var body: some View {
        VStack {
            Text(parameterValue.uppercased())
                .font(.system(size: 15.0, weight: .heavy))

            Text(parameterName.uppercased())
                .font(.system(size: 8.0))
        }
        .frame(maxWidth: .infinity)
    }
}
