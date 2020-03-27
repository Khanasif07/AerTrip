//
//  LocationManagerDelegates.swift
//  
//
//  Created by Pramod Kumar on 28/04/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import CoreLocation

// MARK:- Notification Name
//==========================
extension Notification.Name {
    static let didChangeLocationPermission = Notification.Name("didChangeLocationPermission")
}

// MARK:- LOCATION MANAGER DELEGATES
//=====================================
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        printDebug(#function)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug(#function)
        printDebug(locations)
        if let loc = locations.first {
            self.lastUpdatedCoordinate = loc.coordinate
            self.recentCoordinates.append(loc.coordinate)
            self.lastUpdatedCoordinate =  CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            DispatchQueue.main.async { [weak self] in
                self?.locationUpdate?(loc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        printDebug(#function)
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        printDebug(#function)
        return true
    }
}

// MARK:- LOCATION MANAGER (REGION) DELEGATES
//=====================================
extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        printDebug(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        printDebug(#function)
    }
}

// MARK:- DID CHANGE AUTHORIZATION
//=====================================
extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        NotificationCenter.default.post(name: .didChangeLocationPermission, object: status, userInfo: ["status": status])
        
        switch status {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        case .denied:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            manager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
}
