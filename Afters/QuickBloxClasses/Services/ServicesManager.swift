//
//  QMServiceManager.swift
//  sample-chat-swift
//
//  Created by Injoit on 5/22/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import Foundation
//import QMServices
//import Quickblox

// Comment By Sourabh 
/**
 *  Implements user's memory/cache storing, error handling, show top bar notifications.
 */
//class ServicesManager: QMServicesManager {
//
//    var currentDialogID = ""
//    var isProcessingLogOut: Bool!
//    var colors = [
//        UIColor(red: 0.992, green:0.510, blue:0.035, alpha:1.000),
//        UIColor(red: 0.039, green:0.376, blue:1.000, alpha:1.000),
//        UIColor(red: 0.984, green:0.000, blue:0.498, alpha:1.000),
//        UIColor(red: 0.204, green:0.644, blue:0.251, alpha:1.000),
//        UIColor(red: 0.580, green:0.012, blue:0.580, alpha:1.000),
//        UIColor(red: 0.396, green:0.580, blue:0.773, alpha:1.000),
//        UIColor(red: 0.765, green:0.000, blue:0.086, alpha:1.000),
//        UIColor.red,
//        UIColor(red: 0.786, green:0.706, blue:0.000, alpha:1.000),
//        UIColor(red: 0.740, green:0.624, blue:0.797, alpha:1.000)
//    ]
//
//   // private var contactListService : QMContactListService!
//    var notificationService: NotificationService!
//
//    //var lastActivityDate: NSDate!
//
//    override init() {
//        super.init()
//        self.setupContactServices()
//        self.isProcessingLogOut = false
//    }
//
//    private func setupContactServices() {
//        self.notificationService = NotificationService()
//    }
//
//    internal func handleNewMessage(message: QBChatMessage, dialogID: String) {
//
//        guard self.currentDialogID != dialogID else {
//            return
//        }
//
//        guard message.senderID != self.currentUser.id else {
//            return
//        }
//
//        guard let dialog = self.chatService.dialogsMemoryStorage.chatDialog(withID: dialogID) else {
//            print("chat dialog not found")
//            return
//        }
//
//        var dialogName = "SA_STR_NEW_MESSAGE".localized
//        if dialog.type != QBChatDialogType.private {
//            if dialog.name != nil {
//                dialogName = dialog.name!
//            }
//        } else {
//            if let user = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(dialog.recipientID)) {
//                dialogName = user.login!
//            }
//        }
//        QMMessageNotificationManager.showNotification(withTitle: dialogName, subtitle: message.text, type: QMMessageNotificationType.info)
//    }
//
//    // MARK: Last activity date
//
//    var lastActivityDate: NSDate? {
//        get {
//            let defaults = UserDefaults.standard
//            return defaults.value(forKey: "SA_STR_LAST_ACTIVITY_DATE".localized) as! NSDate?
//        }
//        set {
//            let defaults = UserDefaults.standard
//            defaults.set(newValue, forKey: "SA_STR_LAST_ACTIVITY_DATE".localized)
//            defaults.synchronize()
//        }
//    }
//
//    // MARK: QMServiceManagerProtocol
//
//    internal override func handleErrorResponse(_ response: QBResponse) {
//        super.handleErrorResponse(response)
//
//        guard self.isAuthorized else {
//            return
//        }
//
//        var errorMessage : String
//        if response.status.rawValue == 502 {
//            errorMessage = "SA_STR_BAD_GATEWAY".localized
//        } else if response.status.rawValue == 0 {
//            errorMessage = "SA_STR_NETWORK_ERROR".localized
//        } else {
//            errorMessage = (response.error?.error?.localizedDescription.replacingOccurrences(of: "(", with: "", options: String.CompareOptions.caseInsensitive, range: nil).replacingOccurrences(of: ")", with: "", options: String.CompareOptions.caseInsensitive, range: nil))!
//        }
//        QMMessageNotificationManager.showNotification(withTitle: "SA_STR_ERROR".localized,
//                                                      subtitle: errorMessage,
//                                                      type: QMMessageNotificationType.warning)
//    }
//
//    /**
//     Download users accordingly to Constants.QB_USERS_ENVIROMENT
//
//     - parameter successBlock: successBlock with sorted [QBUUser] if success
//     - parameter errorBlock:   errorBlock with error if request is failed
//     */
//    internal func downloadCurrentEnvironmentUsers(successBlock:(([QBUUser]?) -> Void)?, errorBlock:((NSError) -> Void)?) {
//        //
//        //        QBRequest.users(successBlock: { (response, pageInformation, users) in
//        //            print(response)
//        //
//        //            self.usersService.usersMemoryStorage.add(users!)
//        //            successBlock?(self.sortedUsers())
//        //
//        //        }, errorBlock: { (response) in
//        //            print(response)
//        //        })
//        //
//        let pageIndex : UInt = 0
//        let page = QBGeneralResponsePage()
//        page.currentPage = pageIndex
//        page.perPage = 50
//
//        QBRequest.users(for: page, successBlock: { (response, pageInformation, users) in
//
//            self.usersService.usersMemoryStorage.add(users)
//            let users = self.usersService.usersMemoryStorage.unsortedUsers()
//
//            if (pageInformation.totalEntries) > UInt(users.count){
//
//                self.getUserfor(pageIndex: (pageInformation.currentPage) + 1)
//            } else {
//                successBlock?(self.sortedUsers())
//            }
//        }, errorBlock: { (response) in
//            print(response)
//        })
//    }
//
//    internal func getUserfor(pageIndex : UInt) {
//        let page = QBGeneralResponsePage()
//        page.currentPage = pageIndex
//        page.perPage = 50
//        QBRequest.users(for: page, successBlock: { (response, pageInformation, users) in
//            self.usersService.usersMemoryStorage.add(users)
//            let users = self.usersService.usersMemoryStorage.unsortedUsers()
//            if (pageInformation.totalEntries) > UInt(users.count) {
//                self.getUserfor(pageIndex: (pageInformation.currentPage) + 1)
//            } else {
//                return
//            }
//        }, errorBlock: { (response) in
//            print(response)
//        })
//    }
//
//    internal func getUserFromExternalId(externalId : UInt ,  successBlock:((QBUUser?) -> Void)?, errorBlock:((NSError) -> Void)?)
//    {
//        // Changes By Sourabh
//
//        //    self.usersService.getUserWithExternalID(externalId).continueWith({ (user) -> Any? in
//        //            print(user)
//        //
//        //            if let error = user.error {
//        //
//        //                errorBlock?(error as NSError)
//        //                return nil
//        //            }
//        //
//        //            successBlock?(user.result)
//        //            return nil
//        //
//        //        })
//        //
//        self.usersService.getUserWithExternalID(externalId, forceLoad: true).continueWith { user in
//            if let error = user.error {
//                errorBlock?(error as NSError)
//                return nil
//            }
//            successBlock?(user.result)
//            return nil
//        }
//    }
//
//    internal func signUpAndLogin(user : QBUUser) {
//        self.authService.signUpAndLogin(with: user, completion: {(response, user) -> Void in
//            print(response.error)
//            //             print(response.data)
//            print(response.isSuccess)
//            print(response.status)
//        })
//    }
//
//    internal func color(forUser user:QBUUser) -> UIColor {
//        let defaultColor = UIColor.black
//        let users = self.usersService.usersMemoryStorage.unsortedUsers()
//        guard let givenUser = self.usersService.usersMemoryStorage.user(withID: user.id) else {
//            return defaultColor
//        }
//        let indexOfGivenUser = users.firstIndex(of: givenUser)
//        if indexOfGivenUser! < self.colors.count {
//            return self.colors[indexOfGivenUser!]
//        } else {
//            return defaultColor
//        }
//    }
//
//    /**
//     Sorted users
//
//     - returns: sorted [QBUUser] from usersService.usersMemoryStorage.unsortedUsers()
//     */
//    internal func sortedUsers() -> [QBUUser]? {
//        let unsortedUsers = self.usersService.usersMemoryStorage.unsortedUsers()
//        let sortedUsers = unsortedUsers.sorted(by: { (user1, user2) -> Bool in
//            return user1.login!.compare(user2.login!, options:NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
//        })
//        return sortedUsers
//    }
//
//    /**
//     Sorted users without current user
//
//     - returns: [QBUUser]
//     */
//    internal func sortedUsersWithoutCurrentUser() -> [QBUUser]? {
//        guard let sortedUsers = self.sortedUsers() else {
//            return nil
//        }
//        let sortedUsersWithoutCurrentUser = sortedUsers.filter({ $0.id != self.currentUser.id})
//        return sortedUsersWithoutCurrentUser
//    }
//
//    // MARK: QMChatServiceDelegate
//
//    internal override func chatService(_ chatService: QMChatService, didAddMessageToMemoryStorage message: QBChatMessage, forDialogID dialogID: String) {
//        super.chatService(chatService, didAddMessageToMemoryStorage: message, forDialogID: dialogID)
//        if self.authService.isAuthorized {
//            self.handleNewMessage(message: message, dialogID: dialogID)
//        }
//    }
//
//    private func logoutUserWithCompletion(completion: @escaping (_ result: Bool)->()) {
//        if self.isProcessingLogOut! {
//            completion(false)
//            return
//        }
//        self.isProcessingLogOut = true
//        let logoutGroup = DispatchGroup()
//        logoutGroup.enter()
//        let deviceIdentifier = UIDevice.current.identifierForVendor!.uuidString
//        QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (response) -> Void in
//            print("Successfuly unsubscribed from push notifications")
//            logoutGroup.leave()
//        }) { (error) -> Void in
//            print("Push notifications unsubscribe failed")
//            logoutGroup.leave()
//        }
//        logoutGroup.notify(queue: DispatchQueue.main) { [weak self] () -> Void in
//            // Logouts from Quickblox, clears cache.
//            guard let strongSelf = self else { return }
//            strongSelf.logout {
//                strongSelf.isProcessingLogOut = false
//                completion(true)
//            }
//        }
//    }
//}
