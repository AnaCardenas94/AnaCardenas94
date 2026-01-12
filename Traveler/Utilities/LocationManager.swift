//
//  LocationManager.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 03/12/25.
//

import CoreLocation
internal import Combine
import MapKit
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var city: String?
    @Published var country: String?
    @Published var fullLocation: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        self.location = last
        
        reverseGeocode(location: location ?? CLLocation())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
    
    private func reverseGeocode(location: CLLocation) {
        let request = MKReverseGeocodingRequest(location: location)
        
        Task {
            do {
                let mapItems = try await request?.mapItems

                if let item = mapItems?.first {
                    var resolvedCity = ""
                    var resolvedCountry = ""
                    var resolvedFullLocation = ""

                    if let addressReps = item.addressRepresentations {
                        resolvedCity = addressReps.cityName ?? ""
                        resolvedCountry =  addressReps.regionName ?? ""
                        resolvedFullLocation = addressReps.cityWithContext ?? ""
                    }
                    
                    if resolvedCity.isEmpty {
                        resolvedCity = item.name ?? ""
                    }
                    if resolvedCountry.isEmpty {
                        resolvedCountry = item.name ?? ""
                    }
                    if resolvedFullLocation.isEmpty {
                        resolvedFullLocation = item.name ?? ""
                    }
                    await MainActor.run {
                        self.city = resolvedCity
                        self.country = resolvedCountry
                        self.fullLocation = resolvedFullLocation
                    }
                }
            } catch {
                print("MKReverseGeocodingRequest falló:", error)
            }
        }
    }
}
