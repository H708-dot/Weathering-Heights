//
//  Weathering_HeightsApp.swift
//  Weathering Heights
//
//  Created by Jayanth R on 29/06/2024.
//

import SwiftUI

@main
struct Weathering_HeightsApp: App {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                HomeView()
            } else {
                WelcomeView()
            }
        }
    }
}
