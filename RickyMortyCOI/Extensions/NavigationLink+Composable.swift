//
//  NavigationLink+Composable.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 16/02/2024.
//

import SwiftUI

extension NavigationLink {
    init<D, C: View>(
        item: Binding<D?>,
        @ViewBuilder destination: (D) -> C,
        @ViewBuilder label: () -> Label
      ) where Destination == C? {
        self.init(
          destination: item.wrappedValue.map(destination),
          isActive: Binding(
            get: { item.wrappedValue != nil },
            set: { isActive, transaction in
              if !isActive {
                item.transaction(transaction).wrappedValue = nil
              }
            }
          ),
          label: label
        )
      }
}
