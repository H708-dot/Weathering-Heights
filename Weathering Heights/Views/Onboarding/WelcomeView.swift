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
                VStack {
                    TabView(selection: $currentStep) {
                        ForEach(0..<onboardingSteps.count, id: \.self) { index in
                            VStack(spacing: 25) {
                            VStack(spacing: 25) {
                                // Icon with float animation
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
                                
                                // Glass Card
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
                                .padding(.horizontal, 20)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 500)
                    
                    Spacer()
                    
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
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
