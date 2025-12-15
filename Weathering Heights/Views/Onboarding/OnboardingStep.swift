//
//  OnboardingStep.swift
//  Weathering Heights
//
//  Created by Antigravity on 05/07/2024.
//

import Foundation

struct OnboardingStep: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let isSystemImage: Bool
}

let onboardingSteps = [
    OnboardingStep(
        image: "cloud.sun.fill",
        title: "Welcome to\nWeathering Heights",
        description: "Your personalized guide to weather awareness. Stay informed, stay safe.",
        isSystemImage: true
    ),
    OnboardingStep(
        image: "leaf.circle.fill",
        title: "Learn & Grow",
        description: "Dive into quizzes and activities designed to promote climate action and awareness.",
        isSystemImage: true
    ),
    OnboardingStep(
        image: "heart.fill",
        title: "Make an Impact",
        description: "Join us in making a positive impact on our planet, one step at a time.",
        isSystemImage: true
    )
]
