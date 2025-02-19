//
//  EDisonTechCaseStudyApp.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 14.02.2025.
//

import SwiftUI

@main
struct EDisonTechCaseStudyApp: App {
    @StateObject private var locationViewModel = LocationViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationViewModel)
                .onAppear {
                    locationViewModel.startContinuousFetching()
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        locationViewModel.startContinuousFetching()
                    }
                }
                .preferredColorScheme(.dark)
        }
    }
}
