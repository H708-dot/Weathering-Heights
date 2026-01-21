//
//  MapView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.blue)
                
                Text("Map View")
                    .font(.custom("Rubik-Bold", size: 24))
                
                Text("Explore weather patterns across the globe.")
                    .font(.custom("Rubik-Regular", size: 16))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    MapView()
}
