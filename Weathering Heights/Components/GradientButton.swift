//
//  Gradients.swift
//  login
//
//  Created by Hemanth Sai Dasari on 01/07/2024.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(colors: [Color(UIColor(red: 7/255, green: 71/255, blue: 37/255, alpha: 1)), Color(UIColor(red: 6/255, green: 60/255, blue: 29/255, alpha: 1)), Color(UIColor(red: 6/255, green: 48/255, blue: 24/255, alpha: 1))], startPoint: .top, endPoint: .bottom), in: .capsule)
        })
    }
}

#Preview {
    LoginView()
}

struct SocialLoginRow: View {
    var onGoogle: () -> Void = {}
    var onApple: () -> Void = {}
    var onMicrosoft: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 25) {
            // Divider
            HStack(spacing: 15) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("Or continue with")
                    .font(.custom("Rubik-Regular", size: 14))
                    .foregroundStyle(.gray.opacity(0.8))
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 30) {
                // Google
                Button(action: onGoogle) {
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text("G")
                                .font(.custom("Rubik-Bold", size: 28))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .red, .yellow, .green],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                // Apple
                Button(action: onApple) {
                    Circle()
                        .fill(.black)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .offset(y: -2)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                // Microsoft
                Button(action: onMicrosoft) {
                    Circle()
                        .fill(Color(UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1))) // Dark background for MS
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color(UIColor(red: 0/255, green: 164/255, blue: 239/255, alpha: 1)))
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
        .padding(.top, 10)
    }
}
