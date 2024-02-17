//
//  ClearBackground.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 17/02/2024.
//

import SwiftUI

struct ClearBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        return SomeView()
    }

    /// Only needed to fulfill Representable conformance
    func updateUIView(_ uiView: UIView, context: Context) { }

    private class SomeView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()

            superview?.superview?.backgroundColor = .clear
        }
    }
}
