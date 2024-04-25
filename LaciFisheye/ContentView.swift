//
//  ContentView.swift
//  LaciFisheye
//
//  Created by Maciek Czarnik on 25/04/2024.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack {
      Spacer()
      Image(.im)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .layerEffect(
          .init(
            function: .init(library: .default, name: "laci"),
            arguments: [
              .boundingRect
            ]
          ),
          maxSampleOffset: .zero
        )
      Spacer()
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
