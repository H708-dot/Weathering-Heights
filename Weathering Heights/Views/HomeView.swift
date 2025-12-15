//
//  HomeView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Welcome Back!")
                    .font(.custom("Rubik-Bold", size: 36))
                    .foregroundStyle(.white)
                
                Text("You are successfully logged in.")
                    .font(.custom("Rubik-Regular", size: 18))
                    .foregroundStyle(.white.opacity(0.8))
                
                Button(action: {
                    // Logout Action
                    isUserLoggedIn = false
                }, label: {
                    Text("Logout")
                        .font(.custom("Rubik-Bold", size: 16))
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                })
            }
        }
    }
}

#Preview {
    HomeView()
}
