//
//  WelcomeView.swift
//  Weathering Heights
//
//  Created by Jayanth R on 29/06/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentStep = 0
    // Animation states
    @State private var showText = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                    .overlay {
                        // Dark dimming for better text readability
                        Color.black.opacity(0.15)
                            .ignoresSafeArea()
                    }
                
                // Content
                GeometryReader { geometry in
                    let isLandscape = geometry.size.width > geometry.size.height
                    
                    VStack {
                        if !isLandscape {
                            Spacer(minLength: 0)
                        }
                        
                        TabView(selection: $currentStep) {
                            ForEach(0..<onboardingSteps.count, id: \.self) { index in
                                Group {
                                    if isLandscape {
                                        // Landscape: Unified Glass Card
                                        HStack(spacing: 0) {
                                            // Left Panel: Image
                                            ZStack {
                                                elementImage(index: index)
                                                    .padding(20)
                                            }
                                            .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.75) // Fixed proportion
                                            .background(Color.white.opacity(0.1)) // Subtle separation
                                            
                                            // Right Panel: Text + Button
                                            VStack(spacing: 20) {
                                                Spacer()
                                                
                                                Text(onboardingSteps[index].title)
                                                    .font(.custom("Rubik-Bold", size: 30))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text(onboardingSteps[index].description)
                                                    .font(.custom("Rubik-Regular", size: 16))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(.white.opacity(0.9))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Spacer()
                                                
                                                // Button Inside Card
                                                actionButton(index: index)
                                            }
                                            .padding(30)
                                            .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.75)
                                        }
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(30)
                                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
                                    } else {
                                        // Portrait: Stacked
                                        VStack(spacing: 25) {
                                            elementImage(index: index)
                                            elementCardPortrait(index: index)
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: isLandscape ? nil : 500)
                        
                        // Portrait Button (Outside TabView)
                        if !isLandscape {
                            actionButton(index: currentStep)
                                .padding(.horizontal, 40)
                                .padding(.bottom, 50)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
    
    // Helper Views
    @ViewBuilder
    func elementImage(index: Int) -> some View {
        if onboardingSteps[index].isSystemImage {
            Image(systemName: onboardingSteps[index].image)
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, value: index)
                .shadow(color: .white.opacity(0.5), radius: 20)
        } else {
            Image(onboardingSteps[index].image)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .shadow(color: .white.opacity(0.5), radius: 20)
        }
    }
    
    @ViewBuilder
    func elementCardPortrait(index: Int) -> some View {
        VStack(spacing: 15) {
            Text(onboardingSteps[index].title)
                .font(.custom("Rubik-Bold", size: 32))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            Text(onboardingSteps[index].description)
                .font(.custom("Rubik-Regular", size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 10)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    @ViewBuilder
    func actionButton(index: Int) -> some View {
        Button {
            withAnimation {
                if currentStep < onboardingSteps.count - 1 {
                    currentStep += 1
                }
            }
        } label: {
            if index == onboardingSteps.count - 1 {
                 NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                     Text("Get Started")
                        .font(.custom("Rubik-Bold", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)), Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1))], startPoint: .top, endPoint: .bottom)
                        )
                        .foregroundStyle(.black)
                        .cornerRadius(40)
                        .shadow(color: .white.opacity(0.3), radius: 10)
                 }
            } else {
                Text("Next")
                    .font(.custom("Rubik-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial) // In portrait this blends, in landscape it blends. Good.
                    .foregroundStyle(.white)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
