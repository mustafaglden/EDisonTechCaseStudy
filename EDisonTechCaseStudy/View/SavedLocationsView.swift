//
//  SavedLocationsView.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

//import SwiftUI
//import MapKit
//
//struct SavedLocationsView: View {
//    @EnvironmentObject var viewModel: LocationViewModel
//    @State private var editingLocation: SavedLocation?
//    @State private var newName: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Saved Locations")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundStyle(.black)
//                    .padding()
//                List {
//                    ForEach(viewModel.savedLocations, id: \.id) { location in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(location.name.isEmpty ? "Lat: \(location.coordinate.latitude), Lon: \(location.coordinate.longitude)" : location.name)
//                                Text("Lat: \(location.coordinate.latitude)")
//                                Text("Lon: \(location.coordinate.longitude)")
//                            }
//                            Spacer()
//                            Button(action: {
//                                editingLocation = viewModel.savedLocations.first(where: { $0.id == location.id }) //  Find location safely
//                                newName = editingLocation?.name ?? "" //  Assign only if found
//                            }) {
//                                Image(systemName: "pencil")
//                                    .foregroundColor(.blue)
//                            }
//
//                            Button(action: {
//                                viewModel.removeLocation(location)
//                            }) {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                }
//                .sheet(item: $editingLocation) { location in
//                    VStack {
//                        TextField("Enter new name", text: $newName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                        Button("Save") {
//                            guard let editingLocation = editingLocation else { return }
//                            guard !newName.isEmpty else { return }
//                            viewModel.renameLocation(editingLocation, newName: newName)
//                            self.editingLocation = nil
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .onAppear {
//                refreshSavedLocations()
//            }
//        }
//    }
//    private func refreshSavedLocations() {
//        viewModel.savedLocations = UserDefaultsManager.getSavedLocations()
//    }
//}

import SwiftUI
import MapKit

struct SavedLocationsView: View {
    @EnvironmentObject var viewModel: LocationViewModel
    @State private var editMode: EditMode = .inactive
    @State private var editingLocationIndex: Int?
    @State private var newName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Saved Locations")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding()
                List {
                    ForEach(viewModel.savedLocations.indices, id: \ .self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                if editMode == .active && editingLocationIndex == index {
                                    TextField("Enter new name", text: $newName, onCommit: {
                                        saveEdit(index: index)
                                    })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.trailing, 10)
                                } else {
                                    Text(viewModel.savedLocations[index].name.isEmpty ? "Lat: \(viewModel.savedLocations[index].coordinate.latitude), Lon: \(viewModel.savedLocations[index].coordinate.longitude)" : viewModel.savedLocations[index].name)
                                    Text("Lat: \(viewModel.savedLocations[index].coordinate.latitude)")
                                    Text("Lon: \(viewModel.savedLocations[index].coordinate.longitude)")
                                }
                            }
                            Spacer()
                            if editMode == .active {
                                Button(action: {
                                    editingLocationIndex = index
                                    newName = viewModel.savedLocations[index].name
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteLocation)
                }
                .navigationTitle("Saved Locations")
                .toolbar {
                    EditButton()
                }
                .environment(\.editMode, $editMode)
            }
            .onAppear {
                viewModel.savedLocations = UserDefaultsManager.getSavedLocations()
            }
        }
    }
    
    private func saveEdit(index: Int) {
        guard !newName.isEmpty else { return }
        viewModel.renameLocation(viewModel.savedLocations[index], newName: newName)
        editingLocationIndex = nil
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        for index in offsets {
            viewModel.removeLocation(viewModel.savedLocations[index])
        }
    }
}

#Preview {
    SavedLocationsView().environmentObject(LocationViewModel())
}
