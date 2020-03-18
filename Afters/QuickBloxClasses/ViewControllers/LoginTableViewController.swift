//
//  LoginTableViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/31/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit


class LoginTableViewController: UsersListTableViewController, NotificationServiceDelegate {
    
    @IBOutlet weak var buildNumberLabel: UILabel!

    // MARK: ViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //		self.buildNumberLabel.text = self.versionBuild();
      //  let currentUser = QBUUser()
        let userinfo = LoginUserHelper.sharedInstance
        let user = userinfo.userInfo()
//        currentUser.password = (user?.email)! + (user?.userId)!
//        currentUser.login = (user?.email)!
//        currentUser.email = (user?.email)!
        SVProgressHUD.show(withStatus: "Loading...", maskType: SVProgressHUDMaskType.clear)
        
        // Logging to Quickblox REST API and chat.
        // Comment By Sourabh 
//        ServicesManager.instance().logIn(with: currentUser, completion: {
//            [weak self] (success,  errorMessage) -> Void in
//
//            guard let strongSelf = self else {
//                return
//            }
//            guard success else {
//                SVProgressHUD.showError(withStatus: errorMessage)
//                return
//            }
//
//            strongSelf.registerForRemoteNotification()
//            //			SVProgressHUD.showSuccess(withStatus: "SA_STR_LOGGED_IN".localized)
//
//            if (ServicesManager.instance().notificationService.pushDialogID != nil) {                ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(delegate: strongSelf)
//            }
//            else {
//                strongSelf.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
//            }
//        })
        self.tableView.reloadData()
    }

    // MARK:- NotificationServiceDelegate protocol
	
    func notificationServiceDidStartLoadingDialogFromServer() {
        SVProgressHUD.show(withStatus: "SA_STR_LOADING_DIALOG".localized, maskType: SVProgressHUDMaskType.clear)
    }
	
    func notificationServiceDidFinishLoadingDialogFromServer() {
        SVProgressHUD.dismiss()
    }
    
  //  func notificationServiceDidSucceedFetchingDialog(chatDialog: QBChatDialog!) {
        // Comment By Sourabh
      //  let dialogsController = self.storyboard?.instantiateViewController(withIdentifier: "DialogsViewController") as! DialogsViewController
        //let chatController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //chatController.dialog = chatDialog

        //self.navigationController?.viewControllers = [dialogsController, chatController]
        //self.navigationController?.viewControllers = [dialogsController]
  //  }
    
    func notificationServiceDidFailFetchingDialog() {
        self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
    }
    
    @IBAction func openLeftMenu(_ sender:UIBarButtonItem ) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewController().showLeftView(animated: true, completionHandler: nil)
    }
    
    // MARK: Actions
	
	/**
	Login in chat with user and register for remote notifications
	
	- parameter user: QBUUser instance
	*/
//    func logInChatWithUser(user: QBUUser) {
        
//        SVProgressHUD.show(withStatus: "Loading...", maskType: SVProgressHUDMaskType.clear)
        // Comment By Sourabh 
        // Logging to Quickblox REST API and chat.
//        ServicesManager.instance().logIn(with: user, completion:{
//            [unowned self] (success, errorMessage) -> Void in
//
//			guard success else {
//				SVProgressHUD.showError(withStatus: errorMessage)
//				return
//			}
//
//			self.registerForRemoteNotification()
//			self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
////			SVProgressHUD.showSuccess(withStatus: "SA_STR_LOGGED_IN".localized)
//
//        })
 //   }
	
    // MARK: Remote notifications
    
    func registerForRemoteNotification() {
        // Register for push in iOS 8
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            // Register for push in iOS 7
            UIApplication.shared.registerForRemoteNotifications(matching: [UIRemoteNotificationType.badge, UIRemoteNotificationType.sound, UIRemoteNotificationType.alert])
        }
    }
    
    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SA_STR_CELL_USER".localized, for: indexPath) as! UserTableViewCell
        cell.isExclusiveTouch = true
        cell.contentView.isExclusiveTouch = true
        // Comment By Sourabh
       // let user = self.users[indexPath.row]
        
//        cell.setColorMarkerText(String(indexPath.row + 1), color: ServicesManager.instance().color(forUser: user))
//        let name = user.fullName ?? ""
//        cell.userDescription = "SA_STR_LOGIN_AS".localized + " " + name
//        cell.tag = indexPath.row
//        cell.profileImage.imageFromUrl(user.customData ?? ""  , isRounded: true)
//        cell.profileImage?.setRounded()

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        // Comment By Sourabh 
//        let user = self.users[indexPath.row]
//        user.password = user.login! + String(user.externalUserID)
// self.logInChatWithUser(user: user)
    }
    
    //MARK: Helpers
    private func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    private func build() -> String {
         return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    private func versionBuild() -> String {
        let version = self.appVersion()
        let build = self.build()
        var versionBuild = String(format:"v%@",version)
        if version != build {
            versionBuild = String(format:"%@(%@)", versionBuild, build )
        }
        return versionBuild as! String
    }
}
