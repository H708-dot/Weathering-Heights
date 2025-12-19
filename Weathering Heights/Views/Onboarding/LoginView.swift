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
                        // Landscape: Unified Glass Modal
                        ZStack {
                            HStack(spacing: 0) {
                                // Left Panel: Branding
                                VStack(spacing: 15) {
                                    Spacer()
                                    Image(systemName: "cloud.sun.fill") // Placeholder Icon or App Icon
                                        .font(.system(size: 60))
                                        .foregroundStyle(.white)
                                        .symbolRenderingMode(.hierarchical)
                                    
                                    Text("Weathering Heights")
                                        .font(.custom("Rubik-Bold", size: 28))
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(isLogin ? "Welcome Back" : "Join our Community")
                                        .font(.custom("Rubik-Regular", size: 16))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 20)
                                    
                                    Spacer()
                                }
                                .frame(width: geometry.size.width * 0.4)
                                .background(Color.black.opacity(0.1)) // Subtle tint to distinguish brand panel
                                
                                // Right Panel: Interactive Form
                                VStack(spacing: 0) {
                                    // Toggle at top of Right Panel
                                    segmentedControl
                                        .padding(.top, 25)
                                        .padding(.horizontal, 30)
                                        .padding(.bottom, 15)
                                    
                                    ScrollView(showsIndicators: false) {
                                        VStack {
                                            if isLogin {
                                                Login(showLogin: $showLogin)
                                                    .transition(.move(edge: .trailing))
                                            } else {
                                                SignUp(showLogin: $showLogin)
                                                    .transition(.move(edge: .leading))
                                            }
                                        }
                                        .padding(.horizontal, 30)
                                        .padding(.bottom, 25)
                                    }
                                }
                                .frame(width: geometry.size.width * 0.5) // Adjust width to fit nicely
                            }
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85) // Modal Size
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
