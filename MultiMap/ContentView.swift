//
//  ContentView.swift
//  MultiMap
//
//  Created by pat on 12/26/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 21.494451, longitude: -157.943498), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var locations = [
        Location(name: "Lanis", latitude: 21.618863, longitude: -158.088967),
        Location(name: "Diamond Head", latitude: 21.253925, longitude: -157.805288)
    ]
    @AppStorage("searchText") private var searchText = ""
    @State private var selectedLocations = Set<Location>()
    
    var body: some View {
        NavigationSplitView {
            List(locations, selection: $selectedLocations) { location in
                Text(location.name)
                    .tag(location)
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            delete(location)
                        }
                    }
            }
            .onDeleteCommand {
                for location in selectedLocations {
                    delete(location)
                }
            }
            .frame(minWidth: 100)
        } detail: {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Text(location.name)
                        .font(.headline)
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .ignoresSafeArea()
        .padding()
        .searchable(text: $searchText, placement: .sidebar)
        .onSubmit(of: .search, runSearch)
        .onChange(of: selectedLocations) { _ in
            var visibleMap = MKMapRect.null
            
            for location in selectedLocations {
                let mapPoint = MKMapPoint(location.coordinate)
                let pointRect = MKMapRect(x: mapPoint.x - 100_000, y: mapPoint.y - 100_000, width: 200_000, height: 200_000)
                visibleMap = visibleMap.union(pointRect)
                var newRegion = MKCoordinateRegion(visibleMap)
                newRegion.span.latitudeDelta *= 1.5
                newRegion.span.longitudeDelta *= 1.5
                withAnimation { region = newRegion
                }
                
            }
        }
    }
    
    func runSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else { return }
            guard let item = response.mapItems.first else { return }
            guard let itemName = item.name, let itemLocation = item.placemark.location else { return }
            
            let newLocation = Location(name: itemName, latitude: itemLocation.coordinate.latitude, longitude: itemLocation.coordinate.longitude)
            locations.append(newLocation)
            
            selectedLocations = [newLocation]
            searchText = ""
        }
    }
    func delete(_ location: Location) {
        guard let index = locations.firstIndex(of: location) else { return }
        locations.remove(at: index)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
