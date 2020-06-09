//
//  LocationManager.swift
//  
//
//  Created by Pramod Kumar on 28/04/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject {

    static let defaultCoordinate = CLLocationCoordinate2DMake(29.3117, 47.4818)
    
    static let shared = LocationManager()
    let manager = CLLocationManager()
    var lastUpdatedCoordinate: CLLocationCoordinate2D?
    var recentCoordinates = [CLLocationCoordinate2D]()
    var lastUpdatedTime = 0
    
    static var getMyLocation: CLLocationCoordinate2D {
        return LocationManager.shared.manager.location?.coordinate ?? LocationManager.defaultCoordinate
    }
    
    // MARK:- Response Closures
    var locationUpdate: ((_ location: CLLocationCoordinate2D, _ error: String?) -> ())?
    
    private override init() {
        super.init()
        
        self.initialSetup()
    }
}

// MARK:- PRIVATE FUNCTIONS
//===========================
extension LocationManager {
    
    /// Initial Setup
    private func initialSetup() {
        
        manager.delegate = self
        manager.activityType = .automotiveNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 20
        //manager.allowDeferredLocationUpdates(untilTraveled: 20, timeout: 1)
    }
}

// MARK:- FUNCTIONS
//===================
extension LocationManager {

    /// Check location services are enabled or not
    func checkLocationServicesAreEnable() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// Request for location When in use
    func requestForLocationWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    /// Request for location Always
    func requestForLocationAlways() {
        manager.requestAlwaysAuthorization()
    }
    
    /// Start location updates
    func startLocationUpdates() {
        self.locationManager(manager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        } else {
            printDebug(#function)
            printDebug("ERROR")
        }
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            manager.startMonitoringSignificantLocationChanges()
        } else {
            printDebug(#function)
            printDebug("ERROR")
        }
    }
    
    /// Start location updates with complition handler
    func startUpdatingLocationWithCompletionHandler(_ completionHandler:((_ location: CLLocationCoordinate2D, _ error: String?) -> ())? = nil){
        
        self.locationUpdate = completionHandler
        
        requestForLocationWhenInUse()
        startLocationUpdates()
    }
    
    /// Stop location updates
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
    }
    
    /// Start Heading updates
    func startHeadingUpdates() {
        manager.startUpdatingHeading()
    }
    
    /// Stop Heading updates
    func stopHeadingUpdates() {
        manager.stopUpdatingHeading()
    }
    
    /// Get Place via Lat Long
    func getPlace(lat: Double, long: Double,
                  place: @escaping (CLPlacemark) -> (),
                  placeError: @escaping (String) -> ())  {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if let placeMarks = placemarks, let firstElement = placeMarks.first {
                place(firstElement)
            } else {
                placeError(error?.localizedDescription ?? "Place Not Found")
            }
        })
    }
    
    /// Get Place via Lat Long
    func getPlace(address: String,
                  place: @escaping (CLPlacemark) -> (),
                  placeError: @escaping (String) -> ())  {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            
            if let placeMarks = placemarks, let firstElement = placeMarks.first {
                place(firstElement)
            } else {
                placeError(error?.localizedDescription ?? "Place Not Found")
            }
        }
    }
    
    /// Open Location in Maps
    func openLocationInMaps(fromCoordinate: CLLocationCoordinate2D?, toCoordinate: CLLocationCoordinate2D) {
        
        var url = "http://maps.apple.com/maps?saddr=\(toCoordinate.latitude),\(toCoordinate.longitude)"
        if let from = fromCoordinate {
            url = "http://maps.apple.com/maps?saddr=\(from.latitude),\(from.longitude)&daddr=\(toCoordinate.latitude),\(toCoordinate.longitude)"
        }
        
        if let url = URL(string:url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let coordinate = CLLocationCoordinate2DMake(toCoordinate.latitude,toCoordinate.longitude)
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                mapItem.name = ""
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            }
        } else {
            let coordinate = CLLocationCoordinate2DMake(toCoordinate.latitude,toCoordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = ""
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
}

