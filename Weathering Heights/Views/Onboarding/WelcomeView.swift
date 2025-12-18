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
                        // Dynamically adjust spacer based on orientation
                        if !isLandscape {
                            Spacer(minLength: 0)
                        }
                        
                        TabView(selection: $currentStep) {
                            ForEach(0..<onboardingSteps.count, id: \.self) { index in
                                Group {
                                    if isLandscape {
                                        // Landscape: Side-by-Side
                                        HStack(spacing: 30) {
                                            // Left: Image
                                            elementImage(index: index)
                                                .frame(maxWidth: geometry.size.width * 0.4)
                                            
                                            // Right: Text Card
                                            ScrollView {
                                                elementCard(index: index)
                                                    .padding(.vertical)
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                        .padding(.horizontal, 40)
                                    } else {
                                        // Portrait: Stacked
                                        VStack(spacing: 25) {
                                            elementImage(index: index)
                                            elementCard(index: index)
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        // Hide default index view in landscape if it overlaps, or keep it.
                        // For now keeping it, but the frame needs to be flexible.
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: isLandscape ? nil : 500) // Flexible in landscape
                        
                        // Button Logic
                        Button {
                            withAnimation {
                                if currentStep < onboardingSteps.count - 1 {
                                    currentStep += 1
                                }
                            }
                        } label: {
                            if currentStep == onboardingSteps.count - 1 {
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
                                    .background(.ultraThinMaterial)
                                    .foregroundStyle(.white)
                                    .cornerRadius(40)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, isLandscape ? 20 : 50)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
    
    // Helper Views for nicer code structure
    @ViewBuilder
    func elementImage(index: Int) -> some View {
        if onboardingSteps[index].isSystemImage {
            Image(systemName: onboardingSteps[index].image)
                .font(.system(size: 100))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, value: index)
                .shadow(color: .white.opacity(0.5), radius: 20)
                .padding(.bottom, 30)
        } else {
            Image(onboardingSteps[index].image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .shadow(color: .white.opacity(0.5), radius: 20)
                .padding(.bottom, 30)
        }
    }
    
    @ViewBuilder
    func elementCard(index: Int) -> some View {
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
            }
        }
    }
}

#Preview {
    WelcomeView()
}
