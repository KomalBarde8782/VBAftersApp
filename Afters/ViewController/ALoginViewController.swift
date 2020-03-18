//
//  ALoginViewController.swift
//  Afters
//
//  Created by Suyog Kolhe on 06/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class ALoginViewController: UIViewController{
    
    @IBOutlet weak var emailIdTextField: NBPTextField!
    @IBOutlet weak var passwordTextField: NBPTextField!
    @IBOutlet weak var loginButton : FBLoginButton?
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        //        loginManager.logOut()
        //self.loginButton!.readPermissions=["public_profile", "email" , ""]
        self.loginButton?.permissions = ["public_profile", "email" , ""]
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,                                               selector:Selector(("receiveToggleAuthUINotification:")),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        statusText.text = ""
        toggleAuthUI()
    }
    
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        self.toggleAuthUI()
        if notification.userInfo != nil {
            let userInfo:Dictionary<String,String?> =
                notification.userInfo as! Dictionary<String,String?>
            self.statusText.text = ""
        }
    }
    
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        if self.validateData() {
            let emailId = self.emailIdTextField.text
            let password = self.passwordTextField.text
            
            UserDefaults.standard.set(emailId!, forKey: "LoginUserEmail")
            UserDefaults.standard.set("Other", forKey: "LoggedInBy")
            
            let registra = LoginRequestModel()
            registra.email = emailId!
            registra.gender = ""
            registra.dob = nil
            registra.password = password!
            // Comment By Sourabh   X
            let registrationPara = RequestHelper.createRequest(registra)
            print(registrationPara)
            self.loginService(withParameter : registrationPara as [String : AnyObject])
        }
    }
        
    @IBAction func googleSignInButtonClicked(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signInSilently()
    }
            
    private func loginButton(_ loginButton: FBLoginButton!, didCompleteWithResult result: LoginManagerLoginResult!, error: NSError!) {
        GraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email"]).start { (connection, result, error) -> Void in
            print("result::\(result)")
            let registra = LoginRequestModel()
            if let result = result as? [String : Any] {
                guard  let email = result["email"] as? String else{
                    return
                }
                let firstname = (result["first_name"] as? String) ?? ""
                let lastName = result["last_name"] as? String ?? ""
                registra.name = firstname + " " + lastName
                
                let data3 = result["picture"] as? [String : Any] ?? ["" : ""]
                let data2 = data3["data"] as? [String : Any] ?? ["" : ""]
                let photoUrl = data2["url"] as? String ?? ""
                registra.profileImage = photoUrl
                registra.dob = nil
                UserDefaults.standard.set(email, forKey: "LoginUserEmail")
                UserDefaults.standard.set("Facebook", forKey: "LoggedInBy")
                
                registra.token = AccessToken.current?.tokenString ?? ""
                registra.email = email
                // Comment By Sourabh 
                let registrationPara = RequestHelper.createRequest(registra)
                print(registrationPara)
                self.loginServiceForSocialNetwork(withParameter : registrationPara as [String : AnyObject] , userData : registra)
            }
        }
        print(result)
    }
            
    @IBAction func forgotButtonClicked(sender: UIButton) {
        let alertController = UIAlertController(title: "Forgot Password", message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: "Reset Password", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.resetPassword(emailId: firstTextField.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email Id"
            textField.text = (self.emailIdTextField?.text)!
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK:- Api Calls
extension ALoginViewController {
    private func loginService(withParameter : [String:AnyObject]) {
        //"userLogin"
        self.showActivity()
        Alamofire.request(BASE_URL + "signin", method: .post, parameters: withParameter, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                self.hideActivity()
                print(response)
                // Cooment By Sourabh
                //let mapper = Mapper<LoginResponseModel>()
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        self.saveLoggedIn(userInfo: mappedObject!.dataObject!)
                //                        self.loadRootViewController()
                //                        //                            self.showAlert("Info", message:mappedObject?.error!.errorMsg  )
                //                    } else {
                //                        self.showAlert("Error", message:mappedObject?.message )
                //                    }
                //                } else {
                //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                }
                
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let baseModel = try JSONDecoder().decode(BaseModel.self, from: response.data ?? Data())
                        if baseModel.errorCode == 0 {
                            //                               self.saveLoggedIn(userInfo: baseModel.dataObject!)
                            //                               self.loadRootViewController()
                            if let data = baseModel.data {
                                if let dataObject = BaseModel.resolveDataInResponse(data: data, toModel: LoginUserInfo.self) {
                                    self.saveLoggedIn(userInfo: dataObject)
                                    self.loadRootViewController()
                                }
                            }
                        } else {
                            self.showAlert("Error", message:baseModel.message )
                        }
                        
                    } catch let error {
                        print("Error = \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
        }
    }
    
    private func loginServiceForSocialNetwork(withParameter : [String:AnyObject] , userData : LoginRequestModel) {
        self.showActivity()
        Alamofire.request(BASE_URL + "userLogin", method: .post, parameters: withParameter, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                self.hideActivity()
                print(response)
                // Comment By Sourabh
                //                let mapper = Mapper<LoginResponseModel>()
                //                if response.result.error == nil {
                //                    let mappedObject = mapper.map(JSONString: response.result.value!)
                //                    if  mappedObject?.errorCode == 0 {
                //                        let userDetail = mappedObject!.dataObject!
                //                        userDetail.name = userData.name
                //                        userDetail.email = userData.email
                //                        userDetail.email2 = userData.email
                //                        userDetail.dob = userData.dob ?? ""
                //                        userDetail.gender = userData.gender
                //                        userDetail.profileImage = userData.profileImage
                //                        userDetail.token = userData.token
                //                        self.saveLoggedIn(userInfo: userDetail )
                //                        self.loadRootViewController()
                //                    } else {
                //                        self.showAlert("Error", message:mappedObject?.message )
                //                    }
                //                } else {
                //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                //                }
                // Written By Sourabh
                if response.result.error == nil {
                    do {
                        let baseModel = try JSONDecoder().decode(BaseModel.self, from: response.data ?? Data())
                        if baseModel.errorCode == 0 {
                            if let data = baseModel.data {
                                if let dataObject = BaseModel.resolveDataInResponse(data: data, toModel: LoginSocialInfo.self) {
                                    if let userDetail = LoginUserInfo(coder: NSCoder()) {
                                        if let userId = dataObject.userId {
                                            userDetail.userId = Int(userId) ?? 0
                                        }
                                        userDetail.name = userData.name
                                        userDetail.email = userData.email
                                        userDetail.email2 = userData.email
                                        userDetail.dob = userData.dob ?? ""
                                        userDetail.gender = userData.gender
                                        userDetail.profileImage = userData.profileImage
                                        userDetail.token = userData.token
                                        self.saveLoggedIn(userInfo: userDetail)
                                        self.loadRootViewController()
                                    }
                                }
                            }
                        } else {
                            self.showAlert("Error", message:baseModel.message )
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

//MARK:- GIDSignInUIDelegate
extension ALoginViewController : GIDSignInUIDelegate, GIDSignInDelegate {
    
    internal func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let isImageAvailable = user.profile.hasImage
            let imageUrl = user.profile.imageURL(withDimension: 200)
            
            let registra = LoginRequestModel()
            registra.token = idToken!
            registra.email = email!
            registra.gender = ""
            registra.dob = nil
            if isImageAvailable {
                registra.profileImage = (imageUrl?.absoluteString)!
            }
            registra.name = fullName!
            UserDefaults.standard.set(email!, forKey: "LoginUserEmail")
            UserDefaults.standard.set("Google", forKey: "LoggedInBy")
            // Comment By Sourabh  X
            let registrationPara = RequestHelper.createRequest(registra)
            print(registrationPara)
            self.loginServiceForSocialNetwork(withParameter : registrationPara as [String : AnyObject] , userData : registra)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    internal func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true) {
        }
    }
    
    internal func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
}

//MARK:- Local functins
extension ALoginViewController{
    
    private func validateData() -> Bool {
        if (self.emailIdTextField != nil)  {
            if let theText = emailIdTextField.text, !theText.isEmpty {
                let isemailValid = self.validate(YourEMailAddress: theText)
                if !isemailValid{
                    self.showAlert("Info", message:"Please enter valid email Id")
                    return false
                }
            } else {
                self.showAlert("Info", message:"Please enter email Id")
                return false
            }
        } else if (self.passwordTextField.text?.isEmpty)! {
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
    
    private func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = ""
        }
    }
    
    private func loadRootViewController() {
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navCtrl = mainStoryBoard.instantiateViewController(withIdentifier: "NavigationController")
        let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NBPRootViewController") as! ARootViewController
        rootViewController.rootViewController = navCtrl
        let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.rootViewController = rootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    private func saveLoggedIn(userInfo : LoginUserInfo ) {
        let defaults = UserDefaults.standard
        // let data  = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        //defaults.set(userInfo, forKey:"LoggedInUserInfo")
        defaults.set(try? PropertyListEncoder().encode(userInfo), forKey: "LoggedInUserInfo")
    }
    
    internal override func showActivity() {
        //        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        loadingNotification.mode = MBProgressHUDMode.indeterminate
        //        loadingNotification.label.text = "Loading"
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "Loading")
    }
    
    internal override func hideActivity() {
        //  MBProgressHUD.hide(for: self.view, animated: true)
        SVProgressHUD.dismiss()
    }
    
    private func resetPassword(emailId : String) {
        
        //        self.view.makeToastActivity(.Center)
        //        Alamofire.request(.POST, BASE_URL+"forgot", parameters:["email": emailId], encoding: .JSON)
        //            .responseString { response in
        //                self.view.hideToastActivity()
        //                debugPrint(response)
        //
        //                let mapper = Mapper<LoginModel>()
        //                let mappedObject = mapper.map(response.result.value)
        //                if response.result.error == nil {
        //                    if  mappedObject?.responseStatus == 1 {
        //
        //                        self.showAlert("Success", message:"We've sent a password reset link to \(emailId) ")
        //
        //                    }else if mappedObject?.errorMsg != nil{
        //                        self.showAlert("Error", message:mappedObject?.errorMsg)
        //                    }
        //                }else{
        //                    self.showAlert("Error", message: response.result.error?.localizedDescription)
        //                }
        //
        //        }
    }
}
