//
//  LeftMenuController.swift
//  Fixtures
//
//  Created by C332268 on 12/02/16.
//  Copyright © 2016 C332268. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Alamofire

class LeftMenuController: UITableViewController{
    
    private var arrayOfStrings: [String] = ["","Home","Profile", "Hosting", "Favourites","Attending", "Chats", "Remove Ads","Logout"]
    private var arrayOfIcons: [String] = ["","ic_home_white","ic_contacts", "ic_library_add", "ic_favorite","ic_thumb_up", "ic_message","ic_touch_app","ic_power_settings_new"]
    
    public let locationManager = CLLocationManager()
    public var isLocationUpdate = false
    public var profileInfo : EditProfileModel?
    internal var tintColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLocationUpdate = false
        self.tableView.backgroundColor = UIColor.white
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfStrings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell : NBPLeftMenuUserInfoCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! NBPLeftMenuUserInfoCell
            let userinfo = LoginUserHelper.sharedInstance
            //
            let user = userinfo.userInfo()
            if user?.email != nil {
                cell.emailId!.text =  user?.email
            }
            cell.icon?.imageFromUrl((user?.profileImage ?? "") , isRounded: true)
            cell.icon?.setRounded()
            cell.userName?.text = user?.name
            return cell
        }
        let cell : LeftMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "leftMenuIdentifier", for: indexPath) as! LeftMenuTableViewCell
        cell.title?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
        cell.icon?.image = UIImage(named: arrayOfIcons[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let purchased = UserDefaults.standard.bool(forKey: IAPIdentifier)
        if (purchased && indexPath.row == 7) {
            return 0
        }
        return UITableView.automaticDimension
    }
        
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
            
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        switch indexPath.row {
        case 1:
            let homeViewController : TabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            homeViewController.selectedIndex = 0
            appDelegate.rootNavigationController().pushViewController(homeViewController, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
        case 2 :
            let homeViewController : TabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            
            let profileViewCtrl = homeViewController.viewControllers?[3] as! ProfileViewController
            profileViewCtrl.editable = false
            homeViewController.selectedIndex = 3
            appDelegate.rootNavigationController().pushViewController(homeViewController, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
        case 3,4,5 :
            switch indexPath.row {
            case 3:
                partyType = .myHosting
            case 4:
                partyType = .myFavourites
            case 5:
                partyType = .myAttending
            default:
                partyType = .none
            }
            let homeViewController : TabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            let navCtrl = homeViewController.viewControllers?[1] as! UINavigationController
            let viewCtrl = navCtrl.viewControllers.first as! FindViewController
            homeViewController.selectedIndex = 1
            viewCtrl.reloadDataFromDataBase()
            appDelegate.rootNavigationController().pushViewController(homeViewController, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
            
        case 6 :
            let myPartiesController  = self.storyboard!.instantiateViewController(withIdentifier: "ChatsNavigationController") as! BaseNavigationController
            let viewCtrl = myPartiesController.viewControllers.first as! LoginTableViewController
            appDelegate.rootNavigationController().pushViewController(viewCtrl, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
                        
        case 7 :
            let myPartiesController : RemoveAdsViewController = self.storyboard!.instantiateViewController(withIdentifier: "RemoveAdsViewController") as! RemoveAdsViewController
            appDelegate.rootNavigationController().pushViewController(myPartiesController, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
            
        case 8 :
            self.showLogOutAlert("Alert", message: "LogOut")
        default:
            let homeViewController : TabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            homeViewController.selectedIndex = 0
            appDelegate.rootNavigationController().pushViewController(homeViewController, animated: true)
            appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
        }
    }    
}

// MARK: - Local Functions
extension LeftMenuController {
    
    override func showAlert(_ title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showLogOutAlert(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "LoggedInUserInfo")
            defaults.synchronize()
            self.logInViewShow()
        }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            action in
        }
        )
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: false, completion: nil)
    }
    
    private func logInViewShow() {
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let navigationController = loginStoryBoard.instantiateInitialViewController()!
        let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.rootViewController = navigationController
    }
}

// MARK: - Api Calls
extension LeftMenuController {
    
    private func getProfile() {
        let registra = EditProfileModel()
        let registrationPara = RequestHelper.createRequest(registra)
        print(registrationPara)
        Alamofire.request(BASE_URL + "getProfile", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                // Comment By Sourabh
                //                let mapper = Mapper<ProfileModel>()
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        let userInfo = mappedObject!.userInfo!
                //                        UserDefaults.standard.set(userInfo.name, forKey: "LeftMenuProfileName")
                //                        UserDefaults.standard.set(userInfo.profileImage, forKey: "LeftMenuProfileImage")
                //                        UserDefaults.standard.set(userInfo.email2, forKey: "LeftMenuProfileemail2")
                //                        let user =  QBUUser()
                //                        user.login = userInfo.email
                //                        user.externalUserID = UInt(Int(userInfo.userId))
                //                        user.password = userInfo.email + String(userInfo.userId)
                //                        user.email = userInfo.email
                //                        user.fullName = userInfo.name
                //                        user.customData = userInfo.profileImage
                //                        ServicesManager.instance().signUpAndLogin(user: user)
                //                        self.tableView.reloadData()
                //                    }else{
                //
                //                    }
                //                }else{
                //               }
                //        }
                // Written By Sourabh 
//                if response.result.error == nil {
//                    do {
//                        let mappedObject = try JSONDecoder().decode(ProfileModel.self, from: response.data ?? Data())
//                        if mappedObject.errorCode == 0 {
//                            let userInfo = mappedObject.userInfo
//                            UserDefaults.standard.set(userInfo?.name, forKey: "LeftMenuProfileName")
//                            UserDefaults.standard.set(userInfo?.profileImage, forKey: "LeftMenuProfileImage")
//                            UserDefaults.standard.set(userInfo?.email2, forKey: "LeftMenuProfileemail2")
//                            // Comment By Sourabh
////                            let user =  QBUUser()
////                            user.login = userInfo?.email
////                            var userId = ""
////                            if let id = userInfo?.userId {
////                                user.externalUserID = UInt(id)
////                                userId = String(id)
////                            }
////                            //user.externalUserID = UInt(Int(userInfo?.userId))
////                            user.password = (userInfo?.email ?? "") + userId
////                            user.email = userInfo?.email
////                            user.fullName = userInfo?.name
////                            user.customData = userInfo?.profileImage
//                           // ServicesManager.instance().signUpAndLogin(user: user)
//                            self.tableView.reloadData()
//                        }
//                    } catch let error {
//                        print("Error \(error.localizedDescription)")
//                    }
//                }
                
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let baseModel = try JSONDecoder().decode(BaseModel.self, from: response.data ?? Data())

                        if baseModel.errorCode == 0 {
                            if let data = baseModel.data {
                                if let dataObject = BaseModel.resolveDataInResponse(data: data, toModel: EditProfileModel.self) {
                                    let userInfo = dataObject
                                    UserDefaults.standard.set(userInfo.name, forKey: "LeftMenuProfileName")
                                    UserDefaults.standard.set(userInfo.profileImage, forKey: "LeftMenuProfileImage")
                                    UserDefaults.standard.set(userInfo.email2, forKey: "LeftMenuProfileemail2")
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    } catch let error {
                        print("Error \(error.localizedDescription)")
                    }
                }
        }
    }
}

// MARK: - locationManager delegate

extension LeftMenuController:CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let coord = location.coordinate
        print(coord.latitude)
        print(coord.longitude)
        if   isLocationUpdate == false{
            isLocationUpdate = true
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
