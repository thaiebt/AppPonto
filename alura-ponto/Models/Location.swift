//
//  Location.swift
//  alura-ponto
//
//  Created by c94289a on 24/03/22.
//

import Foundation
import CoreLocation

protocol LocationDelegate: NSObject {
    func updateUserLocation(latitude: Double?, longitude: Double?)
}

class Location: NSObject {
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    weak var delegate: LocationDelegate?
    
    func permission(_ locationManager: CLLocationManager) {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                break
            case .denied:
                //alert solicitando novamente autorização
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        }
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
        delegate?.updateUserLocation(latitude: latitude, longitude: longitude)
    }
}
