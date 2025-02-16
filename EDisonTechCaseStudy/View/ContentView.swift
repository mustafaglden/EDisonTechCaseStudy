//
//  ContentView.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 14.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SavedLocationsView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
        }
        .accentColor(.red)
    }
}

#Preview {
    ContentView()
}
