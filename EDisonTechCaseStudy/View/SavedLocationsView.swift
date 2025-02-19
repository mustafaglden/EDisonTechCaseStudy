//
//  SavedLocationsView.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

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
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteLocation)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Saved Locations")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            if editMode == .active {
                                Button(action: {
                                    if let index = editingLocationIndex {
                                        saveEdit(index: index)
                                    }
                                    withAnimation {
                                        editMode = .inactive
                                    }
                                }) {
                                    Text("Done")
                                        .fontWeight(.bold)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.primary)
                                        .cornerRadius(8)
                                }
                            } else {
                                Button(action: {
                                    withAnimation {
                                        editMode = .active
                                    }
                                }) {
                                    Text("Edit")
                                        .fontWeight(.bold)
                                        .padding()
                                        .background(Color.cherryRed)
                                        .foregroundColor(.primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
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
        DispatchQueue.main.async {
            viewModel.savedLocations = UserDefaultsManager.getSavedLocations()
        }
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
