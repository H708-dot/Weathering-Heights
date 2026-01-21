//
//  HomeView.swift
//  Weathering Heights
//
//  Created by Antigravity on 15/12/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    
    // Custom Tab Bar Appearance
    init() {
        // Make the tab bar background visible and styled
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)
            
            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "gamecontroller.fill")
                }
                .tag(2)
            
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(3)
        }
        .tint(.blue) // Active tab color
    }
}

#Preview {
    HomeView()
}
