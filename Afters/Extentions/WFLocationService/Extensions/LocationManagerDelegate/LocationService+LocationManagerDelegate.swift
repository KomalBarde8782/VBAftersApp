//
//  LocationService+LocationManagerDelegate.swift
//
//
//  Created by William Falcon on 6/17/15.
//  Copyright (c) 2015 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation

extension LocationService : CLLocationManagerDelegate {
    
    
    
//    private func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //update own coordinates
        let (loc, wasBetter) = mostAccurateLocation(locations.first!)
        
        //update user only if the location is better
        if wasBetter {
            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            let accuracy = loc.horizontalAccuracy
            progressBlock?(lat, lon, accuracy, loc)
            //Print the new coordinates
            print("LocationService: Location updated:\nLat \(lat)\nLon \(lon)\n")
        }
    }
    
    ///Called when user updates authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        startUpdatingLocationIfAuthorized(status)
    }
    
    ///Returns the most accurate location we've seen so far. Updates the last known loc.
    fileprivate func mostAccurateLocation(_ newLocation: CLLocation) -> (mostAccurateLocation :CLLocation, wasBetterLocation : Bool) {
        
        //get last location from manager.
        //if no last set, then use the newLocation
        let manager = LocationService.sharedInstance
        var wasBetter = (manager.updateCount == 0)
        if wasBetter {
            manager.updateCount += 1
        }        
        var lastKnown = manager.lastKnownLocation ?? newLocation
        
        //update if more accurate
        if lastKnown.horizontalAccuracy < newLocation.horizontalAccuracy {
            lastKnown = newLocation
            wasBetter = true
            manager.updateCount += 1
        }
        
        //update manager
        manager.lastKnownLocation = lastKnown
        return (mostAccurateLocation :newLocation, wasBetterLocation : wasBetter)
    }
    
    ///Starts updating location if authorized
    fileprivate func startUpdatingLocationIfAuthorized(_ status: CLAuthorizationStatus) {
        //CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways
        
        // Update delegate's location if user allows authorization
        print("LocationService: Authorization status changed")
        if canAccessLocation() {
            self.startUpdatingLocation()
        }else if (status == CLAuthorizationStatus.denied) {
            let error = NSError(domain: "LocationService", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey:"User did not enable location services!"])
            failUpdateBlock?(error)
        }
    }
}
