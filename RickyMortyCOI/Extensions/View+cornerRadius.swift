//
//  View+cornerRadius.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners))
    }
}

