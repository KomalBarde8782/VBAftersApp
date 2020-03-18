//
//  HostViewController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class HostViewController: BaseViewController , UINavigationControllerDelegate{
    
    private var arrayOfStrings: [String] = ["","Party Title","Party Description", "Party Date", "Party Time", "Music Genre", "Age", "Party Address",""]
    private var placeholders = ["","Enter party title","Enter party description", "Click here for party date", "Click here for party time", "Please select music genre", "Please select age", "Party Address",""]
    
    public let imagePicker = UIImagePickerController()
    public var partyInfo = HostPartyModel()
    public let musicList = HostPartyHelper.musicList()
    public let ageList = HostPartyHelper.ageList()
    public let musicPickerView = UIPickerView()
    public let agePickerView = UIPickerView()
    public var imageView : UIImage?
    public var isEdit = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        musicPickerView.delegate = self
        musicPickerView.dataSource = self
        agePickerView.dataSource = self
        agePickerView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 9.0, *) {
        }else{
            self.tableView.contentInset = UIEdgeInsets.init(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "HostToSelectLocationToHostSegue") {
            if let viewController: SelectLocationToHostPartyViewController = segue.destination as? SelectLocationToHostPartyViewController {
                viewController.delegate = self
            }
        }
    }
}

// MARK: -IBActions
extension HostViewController {
    
    @IBAction func AddImageClicked(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.tabBarController?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func saveButtonClicked() {
        if isEdit {
            self.submitEditedPartyDetail()
        } else {
            if !self.validateData(){
                return
            }
            self.hostPartyApiCall()
        }
    }
    
    @IBAction func deleteSelectedImageClicked() {
        self.imageView = nil
        self.tableView.reloadData()
    }
    
}
// MARK: -Local Fuctions
extension HostViewController {
    
    private func validateData() -> Bool {
        if partyInfo.title == ""{
            self.showAlert("Info", message:"Please enter party title")
            return false
        } else if partyInfo.desc == "" {
            self.showAlert("Info", message:"Please enter party description")
            return false
        } else if partyInfo.partyDate == "" {
            self.showAlert("Info", message:"Please select Party date")
            return false
        } else if partyInfo.time == "" {
            self.showAlert("Info", message:"Please select Party time")
            return false
        } else if partyInfo.music == "" {
            self.showAlert("Info", message:"Please select Music Genre")
            return false
        } else if partyInfo.age == "" {
            self.showAlert("Info", message:"Please select Age Limit")
            return false
        } else if partyInfo.location == "" {
            self.showAlert("Info", message:"Please click here to get address")
            return false
        }
        return true
    }
    
    private  func convertImageToBase64(_ image: UIImage) -> String {
        let compressImage = self.imageWithImage(image, scaledToSize: CGSize(width : 480.0, height: 320.0))
        let imageData = compressImage.jpegData(compressionQuality: 0.6)
        let base64String = imageData!.base64EncodedString(options :[.lineLength64Characters])
        return base64String
    }
    
    private func imageWithImage(_ image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 20, y: 20, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: -Api Calls
extension HostViewController {
    
    private func hostPartyApiCall() {
        let userinfo = LoginUserHelper.sharedInstance
        partyInfo.host = userinfo.userId()
        partyInfo.age = partyInfo.age.replacingOccurrences(of: "+", with: "")
        
        if self.imageView != nil {
            partyInfo.image = self.convertImageToBase64(self.imageView!)
        }        
        // Written By Sourabh (for date only)
        let time = partyInfo.partyTimeDate?.onlyTime12HrString()
        let date = partyInfo.selectedPartyDate?.stringFromDate()
        partyInfo.partyDate = (date ?? "") + " " + (time ?? "")
        partyInfo.partyTimeDate = nil
        partyInfo.selectedPartyDate = nil
        
        let registrationPara = RequestHelper.createRequest(partyInfo)
        print(registrationPara)
        self.showActivity()
        Alamofire.request(BASE_URL + "hostParty", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                self.hideActivity()
                // Comment By Sourabh
//                let mapper = Mapper<LoginResponseModel>()
//                if response.result.error == nil {
//                    let mappedObject = mapper.map(JSONString: response.result.value!)
//                    if  mappedObject?.errorCode == 0 {
//                        self.tabBarController?.selectedIndex = 0
//                    }else{
//                        self.showAlert("Error", message:mappedObject?.message )
//                    }
//                }else{
//                    self.showAlert("Error", message: response.result.error?.localizedDescription)
//                }
                
                // Written By Sourabh
//                if response.result.error == nil {
//                    do {
//                        let mappedObject = try JSONDecoder().decode(LoginResponseModel.self, from: response.data ?? Data())
//                        if mappedObject.errorCode == 0 {
//                            self.tabBarController?.selectedIndex = 0
//                        } else {
//                            self.showAlert("Error", message:mappedObject.message)
//                        }
//                    } catch let error {
//                        print("Error = \(error.localizedDescription)")
//                    }
//                } else {
//                    self.showAlert("Error", message: response.result.error?.localizedDescription)
//                }
                
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let hostParty = try JSONDecoder().decode(HostPartResponse.self, from: response.data ?? Data())                   
                        if hostParty.errorCode == 0 {
                            self.tabBarController?.selectedIndex = 0
                        } else {
                            self.showAlert("Error", message: hostParty.message)
                        }
                    } catch let error {
                        print("Error =\(error.localizedDescription)")
                    }
                } else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
        }
    }
    
    private func submitEditedPartyDetail() {
        if !self.validateData() {
            return
        }
        let userinfo = LoginUserHelper.sharedInstance
        partyInfo.host = userinfo.userId()
        partyInfo.age = partyInfo.age.replacingOccurrences(of: "+", with: "")
        if self.imageView != nil {
            partyInfo.image = self.convertImageToBase64(self.imageView!)
        }
        // Written By Sourabh (for date only)
        let time = partyInfo.partyTimeDate?.onlyTime12HrString()
        let date = partyInfo.selectedPartyDate?.stringFromDate()
        partyInfo.partyDate = (date ?? "") + " " + (time ?? "")        
        partyInfo.partyTimeDate = nil
        partyInfo.selectedPartyDate = nil
        
        let registrationPara = RequestHelper.createRequest(partyInfo)
        print(registrationPara)
        self.showActivity()
        Alamofire.request(BASE_URL + "updateParty", method: .post, parameters: registrationPara, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                print(response)
                self.hideActivity()
                
                // Comment By Sourabh
//                let mapper = Mapper<LoginResponseModel>()
//
//                if response.result.error == nil {
//                    let mappedObject = mapper.map(JSONString: response.result.value!)
//
//                    if  mappedObject?.errorCode == 0 {
//                        self.tabBarController?.selectedIndex = 0
//                    }else{
//                        self.showAlert("Error", message:mappedObject?.message )
//                    }
//                }else{
//                    self.showAlert("Error", message: response.result.error?.localizedDescription)
//                }
                
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let mappedObject = try JSONDecoder().decode(LoginResponseModel.self, from: response.data ?? Data())
                        if mappedObject.errorCode == 0 {
                            self.tabBarController?.selectedIndex = 0
                        } else {
                            self.showAlert("Error", message:mappedObject.message)
                        }
                    } catch let error {
                        print("Error = \(error.localizedDescription)")
                    }
                }
                self.showAlert("Error", message: response.result.error?.localizedDescription)
        }
    }
    
}

// MARK: - Location Delegate
extension HostViewController: LocationSelectionForPartyDelegate {
    
    internal func selected(_ location:CLLocation , address: String){
        partyInfo.location = address
        let coordinate = location.coordinate
        partyInfo.latitude = coordinate.latitude
        partyInfo.longitude = coordinate.longitude
        self.tableView.reloadData()
    }
}

// MARK: - UIImagePickerControllerDelegate Methods
extension HostViewController:UIImagePickerControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

// MARK: - UITableViewDelegate And Data Source Methods
extension HostViewController:UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfStrings.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell : AddImageCell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
            if self.isEdit && self.imageView == nil{
                cell.imageIconView?.imageFromUrl(self.partyInfo.image, image: self.imageView)
            }else{
                cell.imageIconView?.image = self.imageView != nil ? self.imageView : UIImage(named :"ic_add.jpg")
            }
            cell.deleteButton.isHidden = self.imageView != nil ? false : true
            return cell
        case 1:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextField?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            cell.descriptionTextField.tag = 1
            cell.descriptionTextField.text = partyInfo.title
            return cell
        case 2:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextView?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            cell.descriptionTextView.isHidden = false
            cell.descriptionTextField.isHidden = true
            cell.descriptionTextView.tag = 1
            cell.descriptionTextView.text = partyInfo.desc
            return cell
        case 3:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextField?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            //datePickerView.addTarget(self, action: #selector(HostViewController.handleToDatePicker(_:)), for:UIControl.Event.valueChanged)
            datePickerView.addTarget(self, action: #selector(handleToDatePicker(_:)), for: .valueChanged)
            cell.descriptionTextField.inputView = datePickerView
            cell.descriptionTextField.text = partyInfo.partyDate
            cell.descriptionTextField.tag = 3
            return cell
        case 4:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextField?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            let datePickerView:UIDatePicker = UIDatePicker()
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.addTarget(self, action: #selector(HostViewController.handleToTimePicker(_:)), for: UIControl.Event.valueChanged)
            cell.descriptionTextField.inputView = datePickerView
            cell.descriptionTextField.tag = 4
            cell.descriptionTextField.text = partyInfo.time
            return cell
        case 5:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextField?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            cell.descriptionTextField.text = partyInfo.music
            cell.descriptionTextField.inputView = self.musicPickerView
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            return cell
            
        case 6:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextField?.placeholder = placeholders[(indexPath as NSIndexPath).row]
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            cell.descriptionTextField.text = partyInfo.age
            cell.descriptionTextField.inputView = self.agePickerView
            return cell
            
        case 7:
            let cell : PartyAddressCell = tableView.dequeueReusableCell(withIdentifier: "PartyAddressCell", for: indexPath) as! PartyAddressCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            if self.partyInfo.location  == "" {
                cell.addresslabel?.text = "Click here for party address"
            }else {
                cell.addresslabel?.text = self.partyInfo.location
            }
            return cell
            
        case (self.arrayOfStrings.count - 1) :
            let cell : HostSaveCell = tableView.dequeueReusableCell(withIdentifier: "saveCell", for: indexPath) as! HostSaveCell
            return cell
            
        default:
            let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
            cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
            cell.descriptionTextView.isHidden = true
            cell.descriptionTextField.isHidden = false
            return cell
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK:- Target Functions
    @objc func handleToTimePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        partyInfo.time = sender.date.timeStringFromDate()
        partyInfo.partyTimeDate = sender.date
        let indexPath = IndexPath(row: 4, section: 0)
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                let cell = self.tableView.cellForRow(at: indexPath) as! HostDetailCell
                cell.descriptionTextField.text = partyInfo.time
            }
        }
    }
    
    @objc func handleToDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        partyInfo.partyDate = sender.date.newStringFromDate()
        partyInfo.selectedPartyDate = sender.date
        let indexPath = IndexPath(row: 3, section: 0)
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                let cell = self.tableView.cellForRow(at: indexPath) as! HostDetailCell
                cell.descriptionTextField.text = partyInfo.partyDate
            }
        }
    }
}

// MARK: - UIPickerViewDelegate And Data Source Methods
extension HostViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch pickerView {
        case musicPickerView :
            return (musicList?.count)!
        default:
            return (ageList?.count)!
        }
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch pickerView {
        case musicPickerView :
            return musicList?[row]
        default:
            return ageList?[row]
        }
        
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case musicPickerView :
            partyInfo.music = (musicList?[row])!
            let indexPath = IndexPath(row: 5, section: 0)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    let cell = self.tableView.cellForRow(at: indexPath) as! HostDetailCell
                    cell.descriptionTextField.text = partyInfo.music
                }
            }
        default:
            partyInfo.age = (ageList?[row])!
            let indexPath = IndexPath(row: 6, section: 0)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    let cell = self.tableView.cellForRow(at: indexPath) as! HostDetailCell
                    cell.descriptionTextField.text = partyInfo.age
                }
            }
        }
    }
}

// MARK: - UITextField Delegate Methods
extension HostViewController {
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField){
        switch textField.tag {
        case 1:
            partyInfo.title = textField.text!
        default:
            print(textField.text)
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView){
        partyInfo.desc = textView.text!
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
