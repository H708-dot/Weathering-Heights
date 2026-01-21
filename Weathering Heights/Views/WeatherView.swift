//
//  WeatherView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI
import FirebaseAuth

struct WeatherView: View {
    @ObservedObject private var authManager = AuthManager.shared
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Weather Dashboard")
                    .font(.custom("Rubik-Bold", size: 36))
                    .foregroundStyle(.white)
                
                if let user = authManager.currentUser {
                    Text("Hello, \(user.displayName ?? "User")")
                        .font(.custom("Rubik-Medium", size: 20))
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Text("Current Weather: Sunny ☀️")
                    .font(.custom("Rubik-Regular", size: 18))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer().frame(height: 20)
                
                // Temporary Logout Button placement
                Button(action: {
                    authManager.signOut()
                }, label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                    .font(.custom("Rubik-Bold", size: 16))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
                })
            }
        }
    }
}

#Preview {
    WeatherView()
}
