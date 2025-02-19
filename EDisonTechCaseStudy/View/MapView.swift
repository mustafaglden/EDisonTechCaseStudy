//
//  MapView.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: LocationViewModel
    @State private var mapPosition: MapCameraPosition = .automatic
    @State private var isFollowingMarker = false
    @State private var savedLocations: [SavedLocation] = UserDefaultsManager.getSavedLocations()
    
    var body: some View {
        ZStack {
            if viewModel.region != nil {
                Map(position: $mapPosition) {
                    Annotation("", coordinate: viewModel.currentLocation.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                                .shadow(radius: 4)
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 20))
                        }
                    }

                    ForEach(viewModel.savedLocations) { location in
                        Annotation(location.name, coordinate: location.coordinate.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                }
                .onReceive(viewModel.$currentLocation) { newLocation in
                    if isFollowingMarker {
                        mapPosition = .region(MKCoordinateRegion(
                            center: newLocation.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                }
                .gesture(DragGesture().onChanged { _ in
                    isFollowingMarker = false
                })
            } else {
                ProgressView("Fetching initial coordinate...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
            
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        isFollowingMarker = true
                        mapPosition = .region(MKCoordinateRegion(
                            center: viewModel.currentLocation.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }) {
                        Text("Focus on Marker")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        let newLocation = SavedLocation(coordinate: CLLocationCoordinate2DWrapper(viewModel.currentLocation.coordinate), name: "New Location")
                        viewModel.saveLocation(newLocation) // ✅ Call viewModel function
                    }) {
                        Text("Save Location")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    MapView()
}

