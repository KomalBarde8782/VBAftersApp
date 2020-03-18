//
//  FindViewController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreData


class FindViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPartyMessage: UILabel!
    
    public var selectedMarker : GMSMarker!
    public var isMarkerActive = false
    public var parties :[PartyInfo]!
    public var selectedIndex : IndexPath!
    public var markers :[GMSMarker] = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        mapView.delegate = self
        self.parties = CoreDataHelper.getParties()
        self.tableView.reloadData()
        self.addMarkersOnMap()
        self.edgesForExtendedLayout = []
        LocationService.setLocationUpdateTimeLimit(2.0)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(true)
        self.showFilterResult()
    }
    
    override func loadView() {
        super.loadView()
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 1)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PartListToPartyDetailSegue"{
            if let controller: PartyDetailTableViewController = segue.destination as? PartyDetailTableViewController {
                controller.partyInfo = self.parties[selectedIndex.row]
            }
        }
    }
    
}

//MARK:-IBAction
extension FindViewController {
    
    @IBAction func attendingButtonClicked(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let party = self.parties[(indexPath?.row)!]
        let userinfo = LoginUserHelper.sharedInstance
        let registra = PartyIdModel()
        registra.partyId = party.partyId!
        registra.userId = String(userinfo.userId())
        // Comment By Sourabh   X 
        let registrationPara = RequestHelper.createRequest(registra)
        WebService.postService("likeParty", objSelf: self, parameters: registrationPara as [String : AnyObject]) { (response) in
            let basePartyModel : BasePartyModel = response as! BasePartyModel
            self.showAlert("Info", message: basePartyModel.message)
            sender.isSelected = true
            party.isLike = "1"
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func favouritButtonClicked(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        var isFav = "1"
        let party = self.parties[(indexPath?.row)!]
        var serviceName = "favouriteParty"
        if party.isFavourite!.toBool() == true {
            serviceName = "removeFavourite"
            isFav = "0"
        }
        let userinfo = LoginUserHelper.sharedInstance
        let registra = PartyIdModel()
        registra.partyId = party.partyId!
        registra.userId = String(userinfo.userId())
        // Comment By Sourabh       X 
        let registrationPara = RequestHelper.createRequest(registra)
        WebService.postService(serviceName, objSelf: self, parameters: registrationPara as [String : AnyObject]) { (response) in
            let baseModel : BasePartyModel = response as! BasePartyModel
            party.isFavourite = isFav
            sender.isSelected = party.isFavourite!.toBool()
            self.showAlert("Info", message: baseModel.message)
        }
    }
    
    @IBAction func selecteMarker(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let partyInfo = self.parties[(indexPath?.row)!]
        if self.markers.count > (indexPath?.row)! {
            let marker = self.markers[(indexPath?.row)!]
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: Double(partyInfo.latitude!)!, longitude: Double(partyInfo.longitude!)!, zoom: 12)
            self.mapView.selectedMarker = marker
        }
    }
}

//MARK:- Local Functions
extension FindViewController {
    
    private func noPartyStatus() {
        if self.parties == nil {
            self.tableView.isHidden = true
            switch partyType {
            case .myHosting:
                self.noPartyMessage.text = "You are not hosting any party"
            case .myAttending:
                self.noPartyMessage.text = "Not attending any party"
            case .myFavourites:
                self.noPartyMessage.text = "No favourite party"
            default:
                self.noPartyMessage.text = "There are currently no parties within your desired radius please check again soon."
            }
            return
        }
        if self.parties.count == 0 {
            self.tableView.isHidden = true
            switch partyType {
            case .myHosting:
                self.noPartyMessage.text = "You are not hosting any party"
            case .myAttending:
                self.noPartyMessage.text = "Not attending any party"
            case .myFavourites:
                self.noPartyMessage.text = "No favourite party"
            default:
                self.noPartyMessage.text = "There are currently no parties within your desired radius please check again soon."
            }
        } else {
            self.tableView.isHidden = false
        }
    }
    
    private func addMarkersOnMap() {
        self.markers.removeAll()
        self.mapView.clear()
        if self.parties != nil {
            for party in self.parties {
                self.addMarker(Double(party.latitude!)!, long:Double(party.longitude!)!, location: party.location!)
            }
        }
    }
    
    public func reloadDataFromDataBase() {
        self.parties = CoreDataHelper.getParties()
        if self.tableView != nil{
            self.tableView.reloadData()
            self.noPartyStatus()
            self.addMarkersOnMap()
        }
    }
    
    private func showFilterResult() {
        if (UserDefaults.standard.object(forKey: "SelectedFilterValue") as? NSData) != nil{
            self.serachPartyService()
        }else{
            let data  = NSKeyedArchiver.archivedData(withRootObject: FilterSelectionValue())
            let defaults = UserDefaults.standard
            defaults.set(data, forKey:"SelectedFilterValue")
            self.serachPartyService()
        }
    }
    
    private func serachPartyService() {
        LocationService.getCurrentLocationWithProgress({ (latitude, longitude, accuracy, locationObj) in
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
        }, onComplete: { (latitude, longitude, accuracy, locationObj) in
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 7)
            self.findParty(latitude , longitude: longitude )
            print("Location \(latitude) longitude : \(longitude) accuracy : \(accuracy) locationObj : \(locationObj)")
        }) { (error) in
            print("Error = \(error.localizedDescription)")
        }
    }
    
    private func getImageWithColor(color : UIColor) -> UIImage {
        let rect : CGRect = CGRect(origin: CGPoint(x: 0, y: 0) , size: CGSize(width:30 , height: 30) )
        UIGraphicsBeginImageContextWithOptions(CGSize(width:1 , height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
// MARK:- API call
extension FindViewController {
    
    private func  findParty(_ latitude: Double , longitude: Double) {
        let registra = SearchPartyModel()
        if let data = UserDefaults.standard.object(forKey: "SelectedFilterValue") as? NSData{
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! FilterSelectionValue
            print(decodedTeams.partyDateString)
            print(decodedTeams.partyDate)
            registra.partyDate = decodedTeams.partyDateString
            registra.genre = decodedTeams.music
            let age = decodedTeams.age.replacingOccurrences(of: "+", with: "")
            registra.age = age
            let radius = decodedTeams.radius
            registra.radiusInKm = String(decodedTeams.radius)
        }
        let userinfo = LoginUserHelper.sharedInstance
        registra.latitude = String(latitude)
        registra.longitude = String(longitude)
        registra.userId = String(userinfo.userId())
        let registrationPara = RequestHelper.createRequest(registra)
        print(registrationPara)
        self.showActivity()
        Alamofire.request(BASE_URL + "getParty", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                self.hideActivity()
                // Comment By Sourabh
                //                let mapper = Mapper<PartyModel>()
                //                if response.result.value != nil{
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if response.result.error == nil {
                //                        if  mappedObject?.errorCode == 0 && mappedObject?.dataObject != nil{
                //                            self.savePartyInfoInCoreData((mappedObject?.dataObject)!)
                //                        }else if mappedObject?.errorCode == 102 {
                //                            CoreDataHelper.deleteAllFrom("PartyInfo")
                //                            self.parties = CoreDataHelper.getParties()
                //                            self.tableView.reloadData()
                //                            self.addMarkersOnMap()
                //                            self.showAlert("Info", message:mappedObject?.message )
                //                            self.noPartyStatus()
                //                        } else {
                //                            self.showAlert("Error", message:mappedObject?.message )
                //                            self.parties = nil
                //                            self.tableView.reloadData()
                //                            self.addMarkersOnMap()
                //                            self.noPartyStatus()
                //                        }
                //                    }else{
                //                        self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                        self.parties = nil
                //                        self.tableView.reloadData()
                //                        self.addMarkersOnMap()
                //                        self.noPartyStatus()
                //
                //                    }
                //                }
                
                // Written By Sourabh
//                if response.result.value != nil {
//                    do {
//                        let mappedObject = try JSONDecoder().decode(PartyModel.self, from: response.data ?? Data())
//                        if response.result.error == nil {
//                            if  mappedObject.errorCode == 0 && mappedObject.dataObject != nil {
//                                self.savePartyInfoInCoreData((mappedObject.dataObject)!)
//                            } else if mappedObject.errorCode == 102 {
//                                CoreDataHelper.deleteAllFrom("PartyInfo")
//                                self.parties = CoreDataHelper.getParties()
//                                self.tableView.reloadData()
//                                self.addMarkersOnMap()
//                                self.showAlert("Info", message:mappedObject.message )
//                                self.noPartyStatus()
//                            } else {
//                                self.showAlert("Error", message:mappedObject.message )
//                                self.parties = nil
//                                self.tableView.reloadData()
//                                self.addMarkersOnMap()
//                                self.noPartyStatus()
//                            }
//                        }
//                    }
//                    catch let error {
//                        print("Error = \(error.localizedDescription)")
//                    }
//                }
                
                if response.result.value != nil {
                    do {
                        let mappedObjet = try JSONDecoder().decode(PartyModel.self, from: response.data ?? Data())
                        if let data = mappedObjet.data {
                            if let partyModelInfoArray = BaseModel.resolveDataInArrayResponse(data: data, toModel: [PartyModelInfo].self) as? [PartyModelInfo] {
                                if mappedObjet.errorCode == 0 && partyModelInfoArray.count != 0 {
                                    self.savePartyInfoInCoreData(partyModelInfoArray)
                                } else if mappedObjet.errorCode == 102 {
                                    self.parties = CoreDataHelper.getParties()
                                    self.tableView.reloadData()
                                    self.addMarkersOnMap()
                                    self.showAlert("Info", message: mappedObjet.message)
                                    self.noPartyStatus()
                                } else {
                                    self.showAlert("Error", message: mappedObjet.message)
                                    self.parties = nil
                                    self.tableView.reloadData()
                                    self.addMarkersOnMap()
                                    self.noPartyStatus()
                                }
                            }
                        } else {
                            self.showAlert("Info", message: mappedObjet.message)
                        }
                    } catch let error {
                        print("Error \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                    self.parties = nil
                    self.tableView.reloadData()
                    self.addMarkersOnMap()
                    self.noPartyStatus()
                }
        }
    }
}

// MARK:- Core Data Functions
extension FindViewController {
    
    private func savePartyInfoInCoreData(_ parties : [PartyModelInfo]) {
        CoreDataHelper.deleteAllFrom("PartyInfo")
        CoreDataHelper.savePartyInfo(parties)
        self.parties = CoreDataHelper.getParties()
        self.tableView.reloadData()
        self.addMarkersOnMap()
        debugPrint("parties::\(parties)")
        self.noPartyStatus()
    }
}

// MARK:- GMSMapViewDelegate
extension FindViewController : GMSMapViewDelegate {
    
    internal func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?{
        if (self.isMarkerActive){
        }
        return nil
    }
    
    internal func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.isMarkerActive {
            if self.mapView.selectedMarker != nil {
                self.isMarkerActive = false
                self.unHighlightMarker(marker: self.selectedMarker)
                self.selectedMarker = nil
                self.mapView.selectedMarker = nil
            }
        }
    }
    
    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //        if (self.isMarkerActive){
        //            self.unHighlightMarker(marker: marker)
        //        }
        //        self.selectedMarker = marker
        //        self.isMarkerActive = true
        //        self.highlightMarker(marker: marker)
        //
        return false
    }
    
    private func highlightMarker(marker : GMSMarker) {
        if self.mapView.selectedMarker == marker {
            marker.icon = UIImage(named: "location_marker.png")
            let location = GMSCameraPosition.camera(withLatitude: marker.position.latitude,
                                                    longitude: marker.position.longitude, zoom: 11)
            self.mapView.camera = location
        }
    }
    
    private func unHighlightMarker(marker : GMSMarker) {
        if self.mapView.selectedMarker == marker {
            marker.icon = UIImage(named: "not_favouirte.png")
        }
    }
    
    private func addMarker(_ lat : Double, long:Double , location : String) {
        print("Lat ::\(lat) \n Long ::\(long)")
        let position = CLLocationCoordinate2DMake(lat, long)
        let marker = GMSMarker(position: position)
        //        marker.icon = UIImage(named: "not_favouirte.png")
        marker.title = location
        marker.map = mapView
        self.markers.append(marker)
    }
}

// MARK:- Search Filter Delegate
extension FindViewController : SearchFilterDelegate {
    
    func refreshSearchFilter(){
        // Comment By Sourabh
        //self.serachPartyService()
        // Written By Sourabh
        self.showFilterResult()
    }
}
// MARK:- UITableViewDelegate
extension FindViewController:UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var noOfRows = 0
        if self.parties != nil{
            noOfRows = self.parties.count
        }
        return noOfRows
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PartyInfoCell = tableView.dequeueReusableCell(withIdentifier: "PartyInfoCell", for: indexPath) as! PartyInfoCell
        let party = self.parties[indexPath.row]
        cell.titleLabel.text = party.title
        cell.partyDescription.text = party.desc
        cell.age.text = party.age
        cell.attending.text = party.attending
        cell.partyImageView.image = UIImage(named:"default_party_image.jpg")
        if party.image != nil{
            print("Image::\(party.image!)")
            cell.partyImageView.imageFromUrl(party.image! , isRounded: false)
        }
        let isFavourite = party.isFavourite!.toBool()
        cell.favouritButton.isSelected = false
        if isFavourite {
            cell.favouritButton.isSelected = true
        }
        let isLike = party.isLike!.toBool()
        cell.likeButton.isSelected = false
        if isLike {
            cell.likeButton.isSelected = true
        }
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(false)
        self.performSegue(withIdentifier: "PartListToPartyDetailSegue", sender: self)
    }
}
