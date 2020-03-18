//
//  PartyDetailTableViewController.swift
//  Afters
//
//  Created by C332268 on 26/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Firebase
import FacebookShare
import FacebookCore

class PartyDetailTableViewController: UITableViewController , FIRInviteDelegate , GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var partyAddressCell: PartyDetailAddressCell!
    @IBOutlet weak var postPartButton: UIButton!
    @IBOutlet weak var ownerCell: PartyOwnerButtonCell!
    @IBOutlet weak var viewerCell: PartyViewerButtonCell!
    @IBOutlet weak var partyAttendingCell: PartyDetailAddressCell!
    @IBOutlet weak var ageCell: PartyDetailAddressCell!
    @IBOutlet weak var partyinfoCell: PartyDetailInfoCell!
    
    public var partyInfo : PartyInfo!
    //private var dialog: QBChatDialog?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setUpView()
    }
    
    private func setUpView() {
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        partyinfoCell.titleLabel.text = partyInfo.title
        if partyInfo.image != nil {
            partyinfoCell.partyImageView.imageFromUrl(partyInfo.image!  , isRounded: false)
        }
        partyinfoCell.partyDescription.text = partyInfo.desc
        partyinfoCell.dateLabel.text = Date.displayDateWithTime(dateString: partyInfo.dateOfParty!)
        let loginUserId = LoginUserHelper.sharedInstance.userId()
        
        if (partyInfo.isLike?.toBool() == true || Int(partyInfo.host!) == loginUserId ) {
            partyAddressCell.valueLabel.text = partyInfo.location
        }else{
            partyAddressCell.valueLabel.text = "Hidden"
        }
        ageCell.valueLabel.text = partyInfo.age
        partyAttendingCell.valueLabel.text = partyInfo.attending
        
        if Int(partyInfo.host!) == loginUserId {
            self.ownerCell.isHidden = false
            self.viewerCell.isHidden = true
        } else {
            self.ownerCell.isHidden = true
            self.viewerCell.isHidden = false
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Comment By Sourabh
    // Function not used
    private func inviteFinished(withInvitations invitationIds: [Any], error: Error?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            print("Invitations sent")
        }
    }
    
    // Comment By Sourabh
    // Function not used
    open func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.inviteTapped()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PartyDetailToDirectionSegue" {
            if let controller: DirectionViewController = segue.destination as? DirectionViewController {
                controller.partyInfo = self.partyInfo
            }
        } else if segue.identifier == "PartyDetailToChatWithHost" {
            // Comment By Sourabh 
            //            if let chatVC = segue.destination as? ChatViewController {
            //                chatVC.dialog = self.dialog
            //            }
        }
    }
}

// MARK: - IBAction
extension PartyDetailTableViewController {
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let userinfo = LoginUserHelper.sharedInstance
        let registra = PartyIdModel()
        registra.partyId = partyInfo.partyId!
        registra.userId = String(userinfo.userId())
        // Comment By Sourabh       X
        let registrationPara = RequestHelper.createRequest(registra)
        WebService.postService("dropParty", objSelf: self, parameters: registrationPara as [String : AnyObject]) { (response) in
            let baseModel : BasePartyModel = response as! BasePartyModel
            self.showAlert("Info", message: baseModel.message)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func chatWithHostButtonClicked(_ sender: Any) {
        // Comment By Sourabh 
        //self.loginInQuickBox()
    }
    
    @IBAction func getDirectionButtonClicked(_ sender: Any) {
        if partyInfo.isLike?.toBool() == true {
            self.performSegue(withIdentifier: "PartyDetailToDirectionSegue", sender: self)
        } else {
            self.showAlert("Info", message: "To get directions, you have to attend party")
        }
    }
    
    @IBAction func attendPartyButtonClicked(_ sender: Any) {
        let userinfo = LoginUserHelper.sharedInstance
        let registra = PartyIdModel()
        registra.partyId = partyInfo.partyId!
        registra.userId = String(userinfo.userId())
        // Comment By Sourabh       X 
        let registrationPara = RequestHelper.createRequest(registra)
        WebService.postService("likeParty", objSelf: self, parameters: registrationPara as [String : AnyObject]) { (response) in
            let baseModel : BasePartyModel = response as! BasePartyModel
            self.showAlert("Info", message: baseModel.message)
        }
    }
    
    @IBAction func addToFavouritesButtonClicked(_ sender: Any) {
        var serviceName = "favouriteParty"
        if self.partyInfo.isFavourite!.toBool() == true {
            serviceName = "removeFavourite"
        }
        let userinfo = LoginUserHelper.sharedInstance
        let registra = PartyIdModel()
        registra.partyId = self.partyInfo.partyId!
        registra.userId = String(userinfo.userId())
        // Comment By Sourabh       X 
        let registrationPara = RequestHelper.createRequest(registra)
        WebService.postService(serviceName, objSelf: self, parameters: registrationPara as [String : AnyObject]) { (response) in
            let baseModel : BasePartyModel = response as! BasePartyModel
            self.showAlert("Info", message: baseModel.message)
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        let hostViewController = tabBarController.viewControllers?[2] as! HostViewController
        hostViewController.isEdit = true
        hostViewController.partyInfo = HostPartyHelper.partyInfoModelToHostPartyModel(self.partyInfo)
        tabBarController.selectedIndex = 2
    }
    
    // Comment By Sourabh
    // Function not used
    @IBAction func inviteTapped() {
        if let invite = FIRInvites.inviteDialog() {
            invite.setInviteDelegate(self)
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invation type. For example, in an email invite this appears as the subject.
            invite.setMessage(self.partyInfo.desc ?? "")
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle(self.partyInfo.title ?? "")
            invite.setDeepLink("https://itunes.apple.com/app/id1165303730")
            invite.setCallToActionText("Install!")
            invite.setCustomImage(self.partyInfo.image ?? "")
            invite.open()
        }
    }
    
    // Comment By Sourabh
    // Function not used
    @IBAction func facebookPost(sender : UIButton){
        let loggedBy = UserDefaults.standard.value(forKey: "LoggedInBy") as! String
        if loggedBy == "Google" {
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                self.inviteTapped()
            }else {
                //                GIDSignIn.sharedInstance().signIn()
            }
        } else {
            self.postOnFacebbok()
        }
    }
}

// MARK: - Table view data source
extension PartyDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell : PartyDetailInfoCell = cell as! PartyDetailInfoCell
            cell.titleLabel.text = partyInfo.title
            if partyInfo.image != nil {
                cell.partyImageView.imageFromUrl(partyInfo.image! , isRounded: false)
            }
            cell.partyDescription.text = partyInfo.desc
            cell.dateLabel.text = Date.displayDateWithTime(dateString: partyInfo.dateOfParty!)
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let loginUserId = LoginUserHelper.sharedInstance.userId()
        if Int(partyInfo.host!) == loginUserId {
            if indexPath.row == 4 {
                return 0.0
            }
        } else if indexPath.row == 5 {
            return 0.0
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let loginUserId = LoginUserHelper.sharedInstance.userId()
        if Int(partyInfo.host!) == loginUserId {
            if indexPath.row == 4 {
                return 0.0
            }
        } else if indexPath.row == 5 {
            return 0.0
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Local Functions
extension PartyDetailTableViewController {
    
    // Comment By Sourabh
    // Function not used
    private func postOnFacebbok() {
        // Changes By Sourabh
        let shareLinkContent = ShareLinkContent()
        guard let url = URL(string: "https://itunes.apple.com/app/id1165303730") else {
            return
        }
        shareLinkContent.contentURL = url
        //let content = LinkShareContent(url: URL(string: "https://itunes.apple.com/app/id1165303730")!, title: self.partyInfo.title ?? "", description: self.partyInfo.desc ?? "", quote: "", imageURL: URL(string: self.partyInfo.image ?? ""))
        
        //        let content = LinkShareContent(url: NSURL("https://developers.facebook.com"), )
        
        //        do{
        //            try ShareDialog.show(from: self, content: content)
        //
        //        }
        //        catch {
        //
        //        }
        let shareDialog = ShareDialog(fromViewController: self, content: shareLinkContent, delegate: nil)
        shareDialog.show()
    }
    
    // Comment By Sourabh
//    private func getUserFromExternalID() {        ServicesManager.instance().getUserFromExternalId(externalId:UInt(self.partyInfo.host!)! , successBlock: { (user) -> Void in
//            guard let unwrappedUsers = user else {
//                SVProgressHUD.showError(withStatus: "Host Not available")
//                return
//            }
//            SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
//            self.createDialogFrom(user: unwrappedUsers)
//
//        }, errorBlock: { (error) -> Void in
//            SVProgressHUD.showError(withStatus: error.localizedDescription)
//        })
 //   }
    
    // Comment By Sourabh
//    private func createDialogFrom(user : QBUUser) {
//        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.group)
//        chatDialog.name = "Chat with \(user.fullName)"
//        let userId = user.id
//        chatDialog.occupantIDs = [NSNumber(value : userId)]
//        ServicesManager.instance().chatService.createPrivateChatDialog(withOpponent: user, completion: { (response, chatDialog) in
//            self.tabBarController?.tabBar.isHidden = true
//            self.dialog = chatDialog
//            self.performSegue(withIdentifier: "PartyDetailToChatWithHost", sender: self)
//        })
        //        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
        //
        //            self.dialog = chatDialog
        //
        //            self.performSegue(withIdentifier: "PartyDetailToChatWithHost", sender: self)
        //            print("responce:\(response)")
        //
        //        }) { (responce : QBResponse!) -> Void in
        //
        //            print("responce:\(responce.error)")
        //        }
  //  }
    
    // Comment By Sourabh
//    private func loginInQuickBox() {
//        let currentUser = QBUUser()
//        let userinfo = LoginUserHelper.sharedInstance
//        let user = userinfo.userInfo()
//        currentUser.password = (user?.email)! + (user?.userId)!
//        currentUser.login = (user?.email)!
//        currentUser.email = (user?.email)!
//        SVProgressHUD.show(withStatus: "Loading...", maskType: SVProgressHUDMaskType.clear)
//        // Logging to Quickblox REST API and chat.
//        ServicesManager.instance().logIn(with: currentUser, completion: {
//            [weak self] (success,  errorMessage) -> Void in
//            guard let strongSelf = self else {
//                return
//            }
//            guard success else {
//                SVProgressHUD.showError(withStatus: errorMessage)
//                return
//            }
//            strongSelf.getUserFromExternalID()
//            //            strongSelf.registerForRemoteNotification()
//            SVProgressHUD.showSuccess(withStatus: "SA_STR_LOGGED_IN".localized)
//            if (ServicesManager.instance().notificationService.pushDialogID != nil) {
//                //                ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(delegate: strongSelf)
//            }
//            else {
//                //                strongSelf.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
//            }
//        })
//    }
}




/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */


//    @IBAction func facebookButtonPushed(sender: UIButton) {
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
//            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookSheet.setInitialText("Share on Facebook")
//            self.presentViewController(facebookSheet, animated: true, completion: nil)
//        } else {
//            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }

