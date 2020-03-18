//
//  DialogsTableViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 4/1/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit

// Comment By Sourabh 
//class DialogTableViewCellModel: NSObject {
//
//    var detailTextLabelText: String = ""
//    var textLabelText: String = ""
//    var unreadMessagesCounterLabelText : String?
//    var unreadMessagesCounterHiden = true
//    var dialogIcon : UIImage?
//    var dialogIconUrl : String = ""
//
//    init(dialog: QBChatDialog) {
//        super.init()
//
//        switch (dialog.type) {
//        case .publicGroup:
//            self.detailTextLabelText = "SA_STR_PUBLIC_GROUP".localized
//        case .group:
//            self.detailTextLabelText = "SA_STR_GROUP".localized
//        case .private:
//            self.detailTextLabelText = "SA_STR_PRIVATE".localized
//
//            if dialog.recipientID == -1 {
//                return
//            }
//            // Getting recipient from users service.
//            if let recipient = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(dialog.recipientID)) {
//                self.textLabelText = recipient.fullName ?? recipient.login!
//                self.dialogIconUrl = recipient.customData ?? ""
//            }
//        }
//
//        if self.textLabelText.isEmpty {
//            // group chat
//            if let dialogName = dialog.name {
//                self.textLabelText = dialogName
//            }
//        }
//        // Unread messages counter label
//        if (dialog.unreadMessagesCount > 0) {
//            var trimmedUnreadMessageCount : String
//            if dialog.unreadMessagesCount > 99 {
//                trimmedUnreadMessageCount = "99+"
//            } else {
//                trimmedUnreadMessageCount = String(format: "%d", dialog.unreadMessagesCount)
//            }
//            self.unreadMessagesCounterLabelText = trimmedUnreadMessageCount
//            self.unreadMessagesCounterHiden = false
//        } else {
//            self.unreadMessagesCounterLabelText = nil
//            self.unreadMessagesCounterHiden = true
//        }
//    }
//}
//
//class DialogsViewController: UITableViewController, QMChatServiceDelegate, QMChatConnectionDelegate, QMAuthServiceDelegate {
//    private var didEnterBackgroundDate: NSDate?
//    private var observer: NSObjectProtocol?
//    // MARK: - ViewController overrides
//
//    internal override func awakeFromNib() {
//        super.awakeFromNib()
//        let imageView = UIImageView.init(image: UIImage(named:"navBar_White_Icon"))
//        self.navigationItem.titleView = imageView;
//        // calling awakeFromNib due to viewDidLoad not being called by instantiateViewControllerWithIdentifier
//        self.navigationItem.title = ServicesManager.instance().currentUser.fullName!
//        self.navigationItem.leftBarButtonItem = self.createLogoutButton()
//        ServicesManager.instance().chatService.addDelegate(self)
//        ServicesManager.instance().authService.add(self)
//        self.observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) -> Void in
//            if !QBChat.instance.isConnected {
//                SVProgressHUD.show(withStatus: "Loading...", maskType: SVProgressHUDMaskType.clear)
//            }
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(DialogsViewController.didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        if (QBChat.instance.isConnected) {
//            self.getDialogs()
//        }
//    }
//
//    internal override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//
//    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SA_STR_SEGUE_GO_TO_CHAT".localized {
//            // Comment By Sourabh
//            //            if let chatVC = segue.destination as? ChatViewController {
//            //                chatVC.dialog = sender as? QBChatDialog
//            //            }
//        }
//    }
//
//    // MARK: - Notification handling
//    @objc func didEnterBackgroundNotification() {
//        self.didEnterBackgroundDate = NSDate()
//    }
//
//    // MARK: - Actions
//
//    private func createLogoutButton() -> UIBarButtonItem {
//        let logoutButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DialogsViewController.logoutAction))
//        return logoutButton
//    }
//
//    @IBAction func logoutAction() {
//
//        //        if !QBChat.instance().isConnected {
//        //
//        //            SVProgressHUD.showError(withStatus: "Error")
//        //            return
//        //        }
//        //
//        //        SVProgressHUD.show(withStatus: "SA_STR_LOGOUTING".localized, maskType: SVProgressHUDMaskType.clear)
//        //
//        //        ServicesManager.instance().logoutUserWithCompletion { [weak self] (boolValue) -> () in
//        //
//        //            guard let strongSelf = self else { return }
//        //            if boolValue {
//        //                NotificationCenter.default.removeObserver(strongSelf)
//        //
//        //
//        //                if strongSelf.observer != nil {
//        //                    NotificationCenter.default.removeObserver(strongSelf.observer!)
//        //                    strongSelf.observer = nil
//        //                }
//        //
//        //                ServicesManager.instance().chatService.removeDelegate(strongSelf)
//        //                ServicesManager.instance().authService.remove(strongSelf)
//        //
//        //                ServicesManager.instance().lastActivityDate = nil;
//        //
//        //                let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
//        //
//        //                SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
//        //
//        //
//        //
//        //            }
//        //        }
//
//        let appDelegate =
//            UIApplication.shared.delegate as! AppDelegate
//        appDelegate.rootViewController().showLeftView(animated: true, completionHandler: nil)
//    }
//
//    // MARK: - DataSource Action
//
//    private func getDialogs() {
//
//        if let lastActivityDate = ServicesManager.instance().lastActivityDate {
//            ServicesManager.instance().chatService.fetchDialogsUpdated(from: lastActivityDate as Date, andPageLimit: kDialogsPageLimit, iterationBlock: { (response, dialogObjects, dialogsUsersIDs, stop) -> Void in
//
//            }, completionBlock: { (response) -> Void in
//
//                if (response.isSuccess) {
//
//                    ServicesManager.instance().lastActivityDate = NSDate()
//                }
//            })
//        } else {
//            SVProgressHUD.show(withStatus: "Loading...", maskType: SVProgressHUDMaskType.clear)
//            ServicesManager.instance().chatService.allDialogs(withPageLimit: kDialogsPageLimit, extendedRequest: nil, iterationBlock: { (response: QBResponse?, dialogObjects: [QBChatDialog]?, dialogsUsersIDS: Set<NSNumber>?, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
//
//            }, completion: { (response: QBResponse?) -> Void in
//
//                guard response != nil && response!.isSuccess else {
//                    SVProgressHUD.showError(withStatus: "SA_STR_FAILED_LOAD_DIALOGS".localized)
//                    return
//                }
//                SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
//                ServicesManager.instance().lastActivityDate = NSDate()
//            })
//        }
//    }
//
//    // MARK: - DataSource
//
//    private func dialogs() -> [QBChatDialog]? {
//        // Returns dialogs sorted by updatedAt date.
//        return ServicesManager.instance().chatService.dialogsMemoryStorage.dialogsSortByUpdatedAt(withAscending: false)
//    }
//
//    // MARK: - UITableViewDataSource
//
//    internal override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let dialogs = self.dialogs() {
//            return dialogs.count
//        }
//        return 0
//    }
//
//    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//
//    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogcell", for: indexPath) as! DialogTableViewCell
//        if ((self.dialogs()?.count)! < indexPath.row) {
//            return cell
//        }
//        guard let chatDialog = self.dialogs()?[indexPath.row] else {
//            return cell
//        }
//        cell.isExclusiveTouch = true
//        cell.contentView.isExclusiveTouch = true
//        cell.tag = indexPath.row
//        cell.dialogID = chatDialog.id!
//
//        let cellModel = DialogTableViewCellModel(dialog: chatDialog)
//        cell.dialogLastMessage?.text = chatDialog.lastMessageText
//        cell.dialogName?.text = cellModel.textLabelText
//        cell.dialogTypeImage.imageFromUrl(cellModel.dialogIconUrl  , isRounded: true)
//        cell.dialogTypeImage?.setRounded()
//        cell.unreadMessageCounterLabel.text = cellModel.unreadMessagesCounterLabelText
//        cell.unreadMessageCounterHolder.isHidden = cellModel.unreadMessagesCounterHiden
//        return cell
//    }
//
//    // MARK: - UITableViewDelegate
//
//    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if (ServicesManager.instance().isProcessingLogOut!) {
//            return
//        }
//        guard let dialog = self.dialogs()?[indexPath.row] else {
//            return
//        }
//        self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_CHAT".localized , sender: dialog)
//    }
//
//    internal override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    internal override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        guard editingStyle == UITableViewCell.EditingStyle.delete else {
//            return
//        }
//
//        guard let dialog = self.dialogs()?[indexPath.row] else {
//            return
//        }
//        _ = AlertView(title:"SA_STR_WARNING".localized , message:"SA_STR_DO_YOU_REALLY_WANT_TO_DELETE_SELECTED_DIALOG".localized , cancelButtonTitle: "SA_STR_CANCEL".localized, otherButtonTitle: ["SA_STR_DELETE".localized], didClick:{ (buttonIndex) -> Void in
//            guard buttonIndex == 1 else {
//                return
//            }
//            SVProgressHUD.show(withStatus: "SA_STR_DELETING".localized, maskType: SVProgressHUDMaskType.clear)
//
//            let deleteDialogBlock = { (dialog: QBChatDialog!) -> Void in
//
//                // Deletes dialog from server and cache.
//                ServicesManager.instance().chatService.deleteDialog(withID: dialog.id!, completion: { (response) -> Void in
//                    guard response.isSuccess else {
//                        SVProgressHUD.showError(withStatus: "SA_STR_ERROR_DELETING".localized)
//                        print(response.error?.error)
//                        return
//                    }
//                    SVProgressHUD.showSuccess(withStatus: "SA_STR_DELETED".localized)
//                })
//            }
//
//            if dialog.type == QBChatDialogType.private {
//                deleteDialogBlock(dialog)
//            } else {
//                // group
//                let occupantIDs = dialog.occupantIDs!.filter({ (number) -> Bool in
//                    return number.uintValue != ServicesManager.instance().currentUser.id
//                })
//                dialog.occupantIDs = occupantIDs
//                let userLogin = ServicesManager.instance().currentUser.login ?? ""
//                let notificationMessage = "User \(userLogin) " + "SA_STR_USER_HAS_LEFT".localized
//                // Notifies occupants that user left the dialog.
//                ServicesManager.instance().chatService.sendNotificationMessageAboutLeaving(dialog, withNotificationText: notificationMessage, completion: { (error) -> Void in
//                    deleteDialogBlock(dialog)
//                })
//            }
//        })
//    }
//
//    internal override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "SA_STR_DELETE".localized
//    }
//
//    // MARK: - QMChatServiceDelegate
//
//    internal func chatService(_ chatService: QMChatService, didUpdateChatDialogInMemoryStorage chatDialog: QBChatDialog) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService,didUpdateChatDialogsInMemoryStorage dialogs: [QBChatDialog]){
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService, didAddChatDialogsToMemoryStorage chatDialogs: [QBChatDialog]) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService, didAddChatDialogToMemoryStorage chatDialog: QBChatDialog) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService, didDeleteChatDialogWithIDFromMemoryStorage chatDialogID: String) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService, didAddMessagesToMemoryStorage messages: [QBChatMessage], forDialogID dialogID: String) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    internal func chatService(_ chatService: QMChatService, didAddMessageToMemoryStorage message: QBChatMessage, forDialogID dialogID: String) {
//        self.reloadTableViewIfNeeded()
//    }
//
//    // MARK: QMChatConnectionDelegate
//
//    internal func chatServiceChatDidFail(withStreamError error: Error) {
//        SVProgressHUD.showError(withStatus: error.localizedDescription)
//    }
//
//    internal func chatServiceChatDidAccidentallyDisconnect(_ chatService: QMChatService) {
//        SVProgressHUD.showError(withStatus: "SA_STR_DISCONNECTED".localized)
//    }
//
//    internal func chatServiceChatDidConnect(_ chatService: QMChatService) {
//        SVProgressHUD.showSuccess(withStatus: "SA_STR_CONNECTED".localized, maskType:.clear)
//        if !ServicesManager.instance().isProcessingLogOut! {
//            self.getDialogs()
//        }
//    }
//
//    internal func chatService(_ chatService: QMChatService,chatDidNotConnectWithError error: Error){
//        SVProgressHUD.showError(withStatus: error.localizedDescription)
//    }
//
//    internal func chatServiceChatDidReconnect(_ chatService: QMChatService) {
//        SVProgressHUD.showSuccess(withStatus: "Loading...", maskType: .clear)
//        if !ServicesManager.instance().isProcessingLogOut! {
//            self.getDialogs()
//        }
//    }
//
//    // MARK: - Helpers
//    // TODO: This isn’t finished yet
//    private func reloadTableViewIfNeeded() {
//        if !ServicesManager.instance().isProcessingLogOut! {
//            self.tableView.reloadData()
//        }
//    }
//}
