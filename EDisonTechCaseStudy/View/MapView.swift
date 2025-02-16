//
//  MapView.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack {
            //condition check for Data handling
            if Binding($viewModel.region) != nil {
                // Map view with a binding to the region
//                Map(
//                    coordinateRegion: bindingRegion,
//                    annotationItems: [viewModel.currentLocation]
//                ) { location in
//                    // Use the computed property to create the map marker
//                    Marker(coordinate: location.coordinate) {
//                        Text("You")
//                    }
//                    .tint(.blue)
//                    MapMarker(coordinate: location.coordinate, tint: .blue)
//                    
//                }
//                .ignoresSafeArea()
                Map(position: $viewModel.region) {
//                    Marker(coordinate: viewModel.currentLocation.coordinate) {
//                        Text("")
//                    }
                    Annotation("Object", coordinate: viewModel.currentLocation.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(radius: 4)
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 20))
                        }
                    }
                }
                
            } else {
                // While waiting for the first coordinate, show a loading indicator.
                ProgressView("Fetching initial coordinate...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
            
            // Error message overlay at the bottom.
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: viewModel.errorMessage)
            }
        }
        .task {
            // Start the continuous fetching when the view appears.
            await viewModel.startContinuousFetching()
        }
    }
}

#Preview {
    MapView()
}
