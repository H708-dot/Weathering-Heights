//
//  Login_SignUp.swift
//  login
//
//  Created by Hemanth Sai Dasari on 01/07/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isLogin: Bool = true
    @State private var showLogin: Bool = true // Kept for compatibility if passed down, though local state drives the view now.

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    let isLandscape = geometry.size.width > geometry.size.height
                    
                    if isLandscape {
                        // Landscape: Side-by-Side
                        HStack(spacing: 0) {
                            // Left Side: Branding & Toggle
                            VStack {
                                Spacer()
                                Text("Weathering Heights")
                                    .font(.custom("Rubik-Bold", size: 30))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(isLogin ? "Welcome Back" : "Join Us")
                                    .font(.custom("Rubik-Regular", size: 18))
                                    .foregroundStyle(.white.opacity(0.8))
                                
                                Spacer()
                                
                                // Toggle
                                segmentedControl
                                    .frame(width: 250)
                                Spacer()
                            }
                            .frame(width: geometry.size.width * 0.4)
                            .background(.ultraThinMaterial.opacity(0.3))
                            
                            // Right Side: Form
                            ScrollView {
                                VStack {
                                    Spacer(minLength: 50)
                                    if isLogin {
                                        Login(showLogin: $showLogin)
                                            .transition(.move(edge: .trailing))
                                    } else {
                                        SignUp(showLogin: $showLogin)
                                            .transition(.move(edge: .leading))
                                    }
                                    Spacer(minLength: 50)
                                }
                                .padding(.horizontal, 40)
                            }
                            .frame(width: geometry.size.width * 0.6)
                        }
                    } else {
                        // Portrait: Stacked
                        VStack {
                            Spacer(minLength: 60)
                            
                            // Toggle
                            segmentedControl
                                .padding(.horizontal, 40)
                                .padding(.bottom, 20)
                            
                            // Form
                            if isLogin {
                                Login(showLogin: $showLogin)
                                    .transition(.move(edge: .leading))
                            } else {
                                SignUp(showLogin: $showLogin)
                                    .transition(.move(edge: .trailing))
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    var segmentedControl: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring()) {
                    isLogin = true
                }
            } label: {
                Text("Login")
                    .font(.custom("Rubik-Medium", size: 16))
                    .foregroundStyle(isLogin ? .black : .white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(isLogin ? Color.white : Color.clear)
                            .shadow(color: .black.opacity(isLogin ? 0.1 : 0), radius: 5, x: 0, y: 2)
                    )
            }
            
            Button {
                withAnimation(.spring()) {
                    isLogin = false
                }
            } label: {
                Text("Sign Up")
                    .font(.custom("Rubik-Medium", size: 16))
                    .foregroundStyle(!isLogin ? .black : .white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(!isLogin ? Color.white : Color.clear)
                            .shadow(color: .black.opacity(!isLogin ? 0.1 : 0), radius: 5, x: 0, y: 2)
                    )
            }
        }
        .padding(4)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}

#Preview {
    LoginView()
}
