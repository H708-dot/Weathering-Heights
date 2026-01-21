//
//  CommunityView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.green)
                
                Text("Community")
                    .font(.custom("Rubik-Bold", size: 24))
                
                Text("Connect with other climate enthusiasts.")
                    .font(.custom("Rubik-Regular", size: 16))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    CommunityView()
}
