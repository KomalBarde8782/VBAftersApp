//
//  SignUpViewController.swift
//  Afters
//
//  Created by Suyog Kolhe on 29/11/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: NBPTextField!
    @IBOutlet weak var emailIdTextField: NBPTextField!
    @IBOutlet weak var passwordTextField: NBPTextField!
    @IBOutlet weak var dobTextField: NBPTextField!
    var dob : Date?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = NSTimeZone.system
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.year = -18
        let minDate = Calendar.current.date(byAdding: components as DateComponents, to: currentDate)
        components.year = -150
        let maxDate = Calendar.current.date(byAdding: components as DateComponents, to: currentDate)
        datePickerView.minimumDate = maxDate!
        datePickerView.maximumDate = minDate!
        print("minDate: \(minDate!)")
        print("maxDate: \(maxDate!)")
        self.dobTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(SignUpViewController.handleToDatePicker(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func handleToDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dob = sender.date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dobTextField.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        if self.validateData() {
            let emailId = self.emailIdTextField.text
            let password = self.passwordTextField.text
            let name = self.nameTextField.text
            let dob = (self.dob?.stringFromDate())! + " 00:00:00"
            let registra = LoginRequestModel()
            registra.email = emailId!
            registra.gender = ""
            registra.dob = dob
            registra.name = name!
            registra.password = password!
            // Comment By Sourabh 
            let registrationPara = RequestHelper.createRequest(registra)
            print(registrationPara)
            self.loginService(withParameter : registrationPara as [String : AnyObject])
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    private func loginService(withParameter : [String:AnyObject]) {
        self.showActivity()
        Alamofire.request(BASE_URL + "signup", method: .post, parameters: withParameter, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                self.hideActivity()
                // Comment By Sourabh
                //                let mapper = Mapper<LoginResponseModel>()
                //                self.emailIdTextField.text = ""
                //                self.passwordTextField.text = ""
                //                self.nameTextField.text = ""
                //                self.dobTextField.text = ""
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        self.navigationController?.popViewController(animated: true)
                //                        let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!
                //                        window.rootViewController?.showAlert("Info", message: "Sign up success")
                //                    }else{
                //                        self.showAlert("Error", message:mappedObject?.message )
                //                    }
                //                }else{
                //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                }
                
                // Written By Sourabh
                self.emailIdTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.dobTextField.text = ""
                if response.result.error == nil {
                    do {
                        let loginResponseModel = try JSONDecoder().decode(LoginResponseModel.self, from: response.data ?? Data())
                        if loginResponseModel.errorCode == 0 {
                            self.navigationController?.popViewController(animated: true)
                            let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!
                            window.rootViewController?.showAlert("Info", message: "Sign up success")
                        } else {
                            self.showAlert("Error", message: loginResponseModel.message)
                        }
                    } catch let error {
                        print("Error = \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
        }
    }
    
    override func showActivity() {
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "Loading")
    }
    
    override func hideActivity() {
        SVProgressHUD.dismiss()
    }

    private func validateData() -> Bool {
        if (self.nameTextField.text?.isEmpty)! {
            self.showAlert("Info", message:"Please enter user name")
            return false
        } else if (self.emailIdTextField != nil) {
            if (self.emailIdTextField.text?.isEmpty)! {
                self.showAlert("Info", message:"Please enter email Id")
                return false
            }
            if let theText = emailIdTextField.text, !theText.isEmpty {
                let isemailValid = self.validate(YourEMailAddress: theText)
                if !isemailValid {
                    self.showAlert("Info", message:"Please enter valid email Id")
                    return false
                }
            }
        } else if(self.passwordTextField.text?.isEmpty)! {
            self.showAlert("Info", message:"Please enter password")
            return false
        } else if (self.dobTextField.text?.isEmpty)! {
            self.showAlert("Info", message:"Please enter date of birth")
            return false
        }
        return true
    }
    
    private func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
}
