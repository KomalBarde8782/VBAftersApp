//
//  ProfileViewController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds

class ProfileViewController: BaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    public let imagePicker = UIImagePickerController()
    public var profileInfo = EditProfileModel()
    public var imageView : UIImage?
    public var editable = false
    public var arrayOfStrings: [String] = ["","Full name","Email", "Gender", "Date of birth",""]
    public let genderPickerView = UIPickerView()
    public let genders = HostPartyHelper.genders()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1336083592322757/2867596220"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfile()
        self.tableView.reloadData()
        let purchased = UserDefaults.standard.bool(forKey: IAPIdentifier)
        let wantAd = UserDefaults.standard.bool(forKey: "KeepAdsClicked")
        if #available(iOS 9.0, *) {
        }else{
            self.tableView.contentInset = UIEdgeInsets.init(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        if purchased {
            if wantAd {
                self.bannerView.isHidden = false
            }
        } else {
            self.bannerView.isHidden = false
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            profileInfo.name = textField.text!
        case 2:
            profileInfo.email2 = textField.text!
        case 5:
            profileInfo.password = textField.text!
            break
        default:
            print(textField.text)
        }
    }
    
}
//MARK:-IBAction
extension ProfileViewController {
    
    @IBAction func editImageClicked(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.tabBarController?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func removeAdButtonClicked(_ sender: Any) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let myPartiesController : RemoveAdsViewController = self.storyboard!.instantiateViewController(withIdentifier: "RemoveAdsViewController") as! RemoveAdsViewController
        appDelegate.rootNavigationController().pushViewController(myPartiesController, animated: true)
        appDelegate.rootViewController().hideLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func saveButtonClicked() {
        if !self.validateData(){
            return
        }
        let userinfo = LoginUserHelper.sharedInstance
        profileInfo.userId = userinfo.userId()
        // Comment by sourabh
        profileInfo.dob = profileInfo.dateOfBirth ?? ""
        if self.imageView != nil{
            profileInfo.profileImage = self.convertImageToBase64(self.imageView!)
        } else {
            let indexPath = IndexPath(row: 0, section: 0)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    let cell =  self.tableView.cellForRow(at: indexPath) as! ProfileIconCell
                    profileInfo.profileImage = self.convertImageToBase64(cell.iconImageView.image!)
                }
            }
        }
        profileInfo.password = ""
        self.showActivity()
        self.updateProfile()
    }
    
    @IBAction func emailNotiFicationSwitchClicked(_ sender: AnyObject) {
        let notifySwitch = sender as! UISwitch
        profileInfo.emailNotify = notifySwitch.isOn ? 1 : 0
        print("profileInfo?.emailNotify::\(profileInfo.emailNotify)")
    }
    
    @objc func handleToDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        profileInfo.dob = sender.date.newStringFromDate()
        profileInfo.dateOfBirth = sender.date.newStringFromDate()
        
        let indexPath = IndexPath(row: 4, section: 0)
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                let cell = self.tableView.cellForRow(at: indexPath) as! ProfileDetailCell
                cell.valueLabel.text = profileInfo.dob
            }
        }
    }
}

// MARK: - Api Calls
extension ProfileViewController {
    
    private func getProfile() {
        // Comment By Sourabh
        let userinfo = LoginUserHelper.sharedInstance
        let registra = EditProfileModel()
        let registrationPara = RequestHelper.createRequest(registra)
        print(registrationPara)
        self.showActivity()
        Alamofire.request(BASE_URL + "getProfile", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in
                self.hideActivity()
                debugPrint(response)
                // Comment By Sourabh
                //              let mapper = Mapper<ProfileModel>()
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        self.profileInfo = mappedObject!.userInfo!
                //                        if  self.profileInfo?.dob != nil {
                //                            self.profileInfo?.dateOfBirth = Date.googleDateToDate(dateString: (self.profileInfo?.dob)!)
                //                            self.profileInfo?.dob = Date.googleDateToDisplayDate(dateString: (self.profileInfo?.dob)!)
                //                        }
                //                        self.tableView.reloadData()
                //                    }else{
                //                        self.showAlert("Error", message:mappedObject?.message )
                //                    }
                //                }else{
                //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                }
                
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let baseModel = try JSONDecoder().decode(BaseModel.self, from: response.data ?? Data())
                        if baseModel.errorCode == 0 {
                            if let data = baseModel.data {
                                if let dataObject = BaseModel.resolveDataInResponse(data: data, toModel: EditProfileModel.self) {
                                    self.profileInfo = dataObject
                                    if self.profileInfo.dob != nil {
                                        //self.profileInfo.dateOfBirth = Date.googleDateToDate(dateString: (self.profileInfo.dob))
                                        //self.profileInfo.dob = Date.googleDateToDisplayDate(dateString: (self.profileInfo.dob))
                                        self.profileInfo.dateOfBirth = self.convertFormattedString(dateString: self.profileInfo.dob)
                                        self.profileInfo.dob = self.convertFormattedString(dateString: self.profileInfo.dob)
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        } else{
                            self.showAlert("Error", message: baseModel.message)
                        }
                    } catch let error {
                        print("Error = \(error.localizedDescription)")
                    }
                }  else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
        }
    }
    
    private func updateProfile() {        
        let registrationPara = RequestHelper.createRequest(profileInfo)
        print(registrationPara)
        Alamofire.request(BASE_URL + "updateProfile", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in               
                debugPrint(response)
                self.hideActivity()
                // Comment By Sourabh
                //                let mapper = Mapper<LoginResponseModel>()
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        self.saveLoggedIn(userInfo: mappedObject!.dataObject!)
                //                        self.showAlert("Info", message: " Profile updated successfully" )
                //
                //                    }else{
                //                        self.showAlert("Error",message: "User is not updated try again..." )
                //
                //                    }
                //                }else{
                //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                }
                
                // Written By Sourabh
//                if response.result.error == nil {
//                    do {
//                        let mappedObject = try JSONDecoder().decode(LoginResponseModel.self, from: response.data ?? Data())
//                        if mappedObject.errorCode == 0 {
//                            self.saveLoggedIn(userInfo: mappedObject.dataObject!)
//                            self.showAlert("Info", message: " Profile updated successfully" )
//                        } else {
//                            self.showAlert("Error",message: "User is not updated try again..." )
//                        }
//                    } catch let error {
//                        print("Error = \(error.localizedDescription)")
//                    }
//                } else {
//                    self.showAlert("Error", message: response.result.error?.localizedDescription)
//                }
                if response.result.error == nil {
                    do {
                        let baseModel = try JSONDecoder().decode(BaseModel.self, from: response.data ?? Data())
                        if let data = baseModel.data {
                            if let dataObject = BaseModel.resolveDataInResponse(data: data, toModel: LoginResponseModel.self) {
                                
                            }
                        }
                    } catch let error {
                        print("Error = \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
        }
    }
}
// MARK: - Local Functions
extension ProfileViewController {
    
    private func validateData() -> Bool {
        if profileInfo.name == "" {
            self.showAlert("Info", message:"Please enter user name")
            return false
        } else if (profileInfo.email2 != nil) || (profileInfo.email2 == nil) {
            if profileInfo.email2 == nil{
                self.showAlert("Info", message:"Please enter email Id")
                return false
            }
            let email = profileInfo.email2 ?? ""
            let isemailValid = self.validate(YourEMailAddress: email)
            if !isemailValid{
                self.showAlert("Info", message:"Please enter valid email Id")
                return false
            }
        } else if profileInfo.dob == "" {
            self.showAlert("Info", message:"Click here to enter birth date")
            return false
        } else if profileInfo.gender == "" {
            self.showAlert("Info", message:"Please select gender")
            return false
        } else if profileInfo.password == "" {
            self.showAlert("Info", message:"Please enter password")
            return false
        }
        return true
    }
    
    private func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    
    private func saveLoggedIn(userInfo : LoginUserInfo ) {
        //commented by komal
        //        let data  = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        //        let defaults = UserDefaults.standard
        //        defaults.set(data, forKey:"LoggedInUserInfo" )
        
        let defaults = UserDefaults.standard
               // let data  = NSKeyedArchiver.archivedData(withRootObject: userInfo)
               //defaults.set(userInfo, forKey:"LoggedInUserInfo")
        defaults.set(try? PropertyListEncoder().encode(userInfo), forKey: "LoggedInUserInfo")
        
    }
    
    public func convertImageToBase64(_ image: UIImage) -> String {
        let compressImage = self.imageWithImage(image, scaledToSize: CGSize(width : 480.0, height: 320.0))
        let imageData = compressImage.jpegData(compressionQuality: 0.6)
        let base64String = imageData!.base64EncodedString(options :[.lineLength64Characters])
        return base64String
    }
    
    public func imageWithImage(_ image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // Written By Sourabh
    private func convertFormattedString(dateString: String)->String {
        var formattedDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let formateDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            formattedDate = dateFormatter.string(from: formateDate)
        }
        return formattedDate
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            self.imageView = pickedImage
            //Use the selected image
            self.tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfStrings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell : ProfileIconCell = tableView.dequeueReusableCell(withIdentifier: "ProfileIconCell", for: indexPath) as! ProfileIconCell
            if editable{
                cell.editButton.isHidden = false
            }else{
                cell.editButton.isHidden = true
            }
            if self.imageView != nil{
                cell.iconImageView.image = self.imageView
            } else if profileInfo.profileImage != nil {
                cell.iconImageView.imageFromUrl((profileInfo.profileImage) , isRounded: true)
            }
            cell.iconImageView?.setRounded()
            cell.profileName.text = profileInfo.name
            
            let circlePath = UIBezierPath.init(arcCenter: CGPoint(x:cell.editButton.bounds.size.width / 2, y: 0), radius: cell.editButton.bounds.size.height, startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: true)
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            cell.editButton.layer.mask = circleShape
            return cell
        case 5  :
            let cell : ProfileNotificationCell = tableView.dequeueReusableCell(withIdentifier: "ProfileNotificationCell", for: indexPath) as! ProfileNotificationCell
            //cell.notificationSwitch.isOn = profileInfo?.emailNotify.
            if editable{
                cell.notificationSwitch.isEnabled = true
            }else{
                cell.notificationSwitch.isEnabled = false
            }
            return cell
        case 6 :
            if editable {
                let cell : HostSaveCell = tableView.dequeueReusableCell(withIdentifier: "saveProfileCell", for: indexPath) as! HostSaveCell
                return cell
            } else {
                let cell : HostSaveCell = tableView.dequeueReusableCell(withIdentifier: "removeAd", for: indexPath) as! HostSaveCell
                return cell
            }
        default:
            let cell : ProfileDetailCell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailCell", for: indexPath) as! ProfileDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.valueLabel.tag = indexPath.row
            switch indexPath.row {
            case 1:
                if profileInfo.name != nil {
                    cell.valueLabel.text = profileInfo.name
                }
            case 2:
                if profileInfo.email != nil {
                    cell.valueLabel.text = profileInfo.email2
                }
            case 3:
                if profileInfo.gender != nil {
                    cell.valueLabel.text = profileInfo.gender
                }
                cell.valueLabel.inputView = self.genderPickerView
            case 4:
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePicker.Mode.date
                datePickerView.maximumDate = Date()
                datePickerView.addTarget(self, action: #selector(ProfileViewController.handleToDatePicker(_:)), for:UIControl.Event.valueChanged)
                cell.valueLabel.inputView = datePickerView
                if profileInfo.dob != nil {
                    cell.valueLabel.text = profileInfo.dob
                        //self.convertFormattedString(dateString: profileInfo.dob)
                }
            default:
                print("default")
            }
            if editable {
                cell.valueLabel.isEnabled = true
            } else {
                cell.valueLabel.isEnabled = false
            }
            return cell
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

// MARK: - UIPickerViewDelegate And Data Source Methods
extension ProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return (genders?.count)!
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return genders?[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row != 0 {
            profileInfo.gender = (genders?[row])!
            let indexPath = IndexPath(row: 3, section: 0)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    let cell = self.tableView.cellForRow(at: indexPath) as! ProfileDetailCell
                    cell.valueLabel.text = profileInfo.gender
                }
            }
        }
    }
}

// MARK: Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// MARK: Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
