//
//  QuizView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        ZStack {
            Color.purple.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.purple)
                
                Text("Quiz Mode")
                    .font(.custom("Rubik-Bold", size: 24))
                
                Text("Test your climate knowledge!")
                    .font(.custom("Rubik-Regular", size: 16))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    QuizView()
}
