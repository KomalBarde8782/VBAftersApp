//
//  SelectLocationToHostPartyViewController.swift
//  Afters
//
//  Created by C332268 on 20/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class SelectLocationToHostPartyViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var delegate: LocationSelectionForPartyDelegate?
    var address = ""
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        LocationService.setLocationUpdateTimeLimit(2.0)
        LocationService.getCurrentLocationWithProgress({ (latitude, longitude, accuracy, locationObj) in
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
        }, onComplete: { (latitude, longitude, accuracy, locationObj) in
            self.cameraPositionOn(latitude , longitude: longitude )
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
        }) { (error) in
            print("Error = \(error.localizedDescription)")
        }
    }
}

// MARK: - IBAction
extension SelectLocationToHostPartyViewController{
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        self.delegate?.selected(location, address: address)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        UINavigationBar.appearance().tintColor = UIColor().appBarColor()
        UINavigationBar.appearance().barTintColor = UIColor().appBarColor()
        UISearchBar.appearance().barTintColor = UIColor().appBarColor()
        UISearchBar.appearance().tintColor = UIColor.white
        present(autocompleteController, animated: true, completion: nil)
    }
}

// MARK: - Local Functions
extension SelectLocationToHostPartyViewController {
    
    // Get Address from Coordinates
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                print(address)
                print(response?.results())
                self.address = (address.lines?.joined(separator: ", "))!
                self.mapView.clear()
                let position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                // Add Marker to map 
                let marker = GMSMarker(position: position)
                marker.title = self.address
                marker.map = self.mapView
                self.mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
            }
        }
    }
    
    private func getAddressFrom(coordinate: CLLocationCoordinate2D) {
        self.reverseGeocodeCoordinate(coordinate: coordinate)
    }
    
    private func placeAutocomplete(address: String!) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(address, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                }
            }
        })
    }
    
    private func addMarkerFromAddress(_ address : String) {
        //                let geocoder = GMSGeocoder()
        //
        //        geocoder(addMarkerFromAddress(address))
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if ((placemarks?.count)! > 0) {
                let pm: CLPlacemark = (placemarks?[0])!
                self.location = pm.location!
                self.getAddressFrom(coordinate: (pm.location?.coordinate)!)
                print(pm)
            }
        })
        self.placeAutocomplete(address: address)
    }
}

// MARK: - GMSMapViewrDelegate
extension SelectLocationToHostPartyViewController : GMSMapViewDelegate {
    
    // Set Location on maph
    func cameraPositionOn(_ latitude : Double , longitude : Double) {
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
    }
    
    // When Tapp on map - Get Tapped Location co-ordinate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let location: CLLocation =  CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.location = location
        self.getAddressFrom(coordinate: coordinate)
    }
}

// MARK: - CLLocationManagerDelegate
extension SelectLocationToHostPartyViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let coordinate = location?.coordinate
    }
    
}

// MARK: - UiSearcgBar Delegate
extension SelectLocationToHostPartyViewController: UISearchBarDelegate {
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.autocompleteClicked()
    }
    
    internal func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.autocompleteClicked()
        return false
    }
}

// MARK: -GMSAutocompleteViewControllerDelegate
extension SelectLocationToHostPartyViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.address = place.formattedAddress ?? ""
        let location: CLLocation =  CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.location = location
        
        self.mapView.clear()
        
        let marker = GMSMarker(position: place.coordinate)
        marker.title = place.formattedAddress
        marker.map = self.mapView
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14)
        viewController.dismiss(animated: true, completion: nil)
        //        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}



