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
    let locations = [
            Location(name: "Lanis", latitude: 21.618863, longitude: -158.088967),
            Location(name: "Diamond Head", latitude: 21.253925, longitude: -157.805288)
        ]
    
    var body: some View {
        VStack {
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
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
