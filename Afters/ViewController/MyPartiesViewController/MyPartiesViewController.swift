//
//  MyPartiesViewController.swift
//  Afters
//
//  Created by C332268 on 12/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import GoogleMaps

class MyPartiesViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    }
    
    override func loadView() {
        super.loadView()
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 1)
    }
    
}

//MARK:- UITableViewDelegate
extension MyPartiesViewController:UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PartyInfoCell = tableView.dequeueReusableCell(withIdentifier: "MyPartyInfoCell", for: indexPath) as! PartyInfoCell
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "MyPartiesToPartyDetailSegue", sender: self)
    }
    
}

