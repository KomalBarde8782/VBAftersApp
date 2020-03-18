//
//  DirectionViewController.swift
//  Afters
//
//  Created by C332268 on 02/11/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    public var partyInfo : PartyInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = []
        LocationService.getCurrentLocationWithProgress({ (latitude, longitude, accuracy, locationObj) in
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
        }, onComplete: { (latitude, longitude, accuracy, locationObj) in
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 9.0)
            self.mapView.camera = camera
            self.callWebService(latitude, long: longitude)
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
            
        }) { (error) in
            // Written By Sourabh
            print("Error = \(error.localizedDescription)")
        }
    }
}
//MARK:- Api Call
extension DirectionViewController {
    
    private func callWebService(_ lat :Double , long:Double){
        let lati = partyInfo.latitude
        let longi = partyInfo.longitude
        if lati != nil && longi != nil{
           // let urlString : NSString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(lat),\(long)&destination=\(lati!),\(longi!)&key=AIzaSyCmFbvAOx6xGxBJBMrqnU57rIxa2dfwNMA" as NSString
             let urlString : NSString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(lat),\(long)&destination=\(lati!),\(longi!)&key=AIzaSyBPKfpeN4h1c49MMHDX2z4RqU-KB7po7CA" as NSString
            let urlStr : NSString = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            print(urlStr)
            let url = URL(string: urlStr as String)
            let request = URLRequest(url: (url! as NSURL) as URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                // notice that I can omit the types of data, response and error
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonResult)
                        let routes = jsonResult.value(forKey: "routes") as? [AnyObject]
                        
                        //print(routes)
                        if (routes?.count)! > 0{
                            // Changes By Sourabh
                            //let overViewPolyLine = routes![0]["overview_polyline"] as! [String : String]
                            let overViewPolyLine = routes![0].object(forKey: "overview_polyline") as! [String : String]
                            
                            let polyLine = overViewPolyLine["points"]
                            print(polyLine ?? "")
                            if polyLine != ""{
                                //Call on Main Thread
                                DispatchQueue.main.async() {
                                    self.addPolyLineWithEncodedStringInMap(encodedString: polyLine!, lat: lat , long:long)
                                }
                            }
                        }
                    }
                }
                catch{
                    print("Somthing wrong")
                }
            });
            task.resume()
        }
        
    }
}

//MARK:- Local Functions
extension DirectionViewController{
    
    private func addPolyLineWithEncodedStringInMap(encodedString: String , lat: Double , long: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 4
        polyLine.strokeColor = UIColor.blue
        polyLine.map = mapView
        
        let smarker = GMSMarker()
        smarker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        smarker.title = "Your location"
        smarker.map = mapView
        let lati = Double(partyInfo.latitude!)
        let longi = Double(partyInfo.longitude!)
        
        let dmarker = GMSMarker()
        dmarker.position = CLLocationCoordinate2D(latitude: lati!, longitude: longi!)
        dmarker.title = partyInfo.title
        dmarker.map = mapView
        view = mapView
    }
}
