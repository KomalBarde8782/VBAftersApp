//
//  AppDelegate.swift
//  Afters
//
//  Created by Suyog Kolhe on 06/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


//Production "com.christopher.aftersApp"
//Developer "com.Vibosis.AftersApp"
//Shared Secret - 11c0388af67b4505b7db10e54cb9c976

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleMobileAds
import Firebase

var kRootViewController : ARootViewController =  UIApplication.shared.keyWindow?.rootViewController as! ARootViewController
var kNavigationController: UINavigationController = kRootViewController.rootViewController as! UINavigationController

let kQBApplicationID:UInt = 47079
let kQBAuthKey = "BsYQBMamqQZBw6V"
let kQBAuthSecret = "6MLpETCFkgkcTFL"
let kQBAccountKey = "SLmkVHCsgPpudyLG2AMN"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    open func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        print("##########  library path is \(library_path)")
        GIDSignIn.sharedInstance().signOut()
        application.applicationIconBadgeNumber = 0
        self.registerForPushNotifications(application: application)
        
        // Comment By Sourabh
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        //QBSettings.setApplicationID(kQBApplicationID)
//        QBSettings.applicationID = kQBApplicationID
//        //QBSettings.setAuthKey(kQBAuthKey)
//        QBSettings.authKey = kQBAuthKey
//        //QBSettings.setAuthSecret(kQBAuthSecret)
//        QBSettings.authSecret = kQBAuthSecret
//        //QBSettings.setAccountKey(kQBAccountKey)
//        QBSettings.accountKey = kQBAccountKey
//
//        // enabling carbons for chat
//        //QBSettings.carbonsEnabled(true)
//        QBSettings.carbonsEnabled = true
//
//        // Enables Quickblox REST API calls debug console output.
//        //QBSettings.setLogLevel(QBLogLevel.nothing)
//        QBSettings.logLevel = QBLogLevel.nothing
//
//        // Enables detailed XMPP logging in console output.
//        QBSettings.enableXMPPLogging()
                
        FIRApp.configure()
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        if RageProducts.store.isProductPurchased(IAPIdentifier) {
            UserDefaults.standard.set(true, forKey: IAPIdentifier)
        }
                
        //GMSServices.provideAPIKey("AIzaSyCmFbvAOx6xGxBJBMrqnU57rIxa2dfwNMA")
        //AIzaSyBPKfpeN4h1c49MMHDX2z4RqU-KB7po7CA
        GMSServices.provideAPIKey("AIzaSyBPKfpeN4h1c49MMHDX2z4RqU-KB7po7CA")
        GMSPlacesClient.provideAPIKey("AIzaSyBPKfpeN4h1c49MMHDX2z4RqU-KB7po7CA")
        //AIzaSyBPg6a5c6LnUn89J61Zv7rKC-UdsbfKqGU
        GIDSignIn.sharedInstance().delegate = self
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1336083592322757/2867596220");

        //IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.shared.enable = true
        
        let remoteNotification: NSDictionary! = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if (remoteNotification != nil) {
           // ServicesManager.instance().notificationService.pushDialogID = remoteNotification["SA_STR_PUSH_NOTIFICATION_DIALOG_ID".localized] as? String
        }
                
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //            - See more at: http://www.theappguruz.com/blog/facebook-integration-using-swift#sthash.mOzoe4Wy.dpuf
        //        return true
    }

    func registerForPushNotifications(application: UIApplication) {
        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(setting)
        application.registerForRemoteNotifications()
//        let notificationSettings = UIUserNotificationSettings(
//            forTypes: [.badg, .sound, .alert], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
    }
    
    
    func rootViewController() -> ARootViewController {
        kRootViewController =  UIApplication.shared.keyWindow?.rootViewController as! ARootViewController
        return UIApplication.shared.keyWindow?.rootViewController as! ARootViewController
    }
    
    func rootNavigationController() -> UINavigationController{
        let rootViewController : ARootViewController =  UIApplication.shared.keyWindow?.rootViewController as! ARootViewController
        kNavigationController = rootViewController.rootViewController as! UINavigationController
        return  rootViewController.rootViewController as! UINavigationController
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
        // Comment By Sourabh 
//        let subscription: QBMSubscription! = QBMSubscription()
//        subscription.notificationChannel = QBMNotificationChannel.APNS
//        subscription.deviceUDID = deviceIdentifier
//        subscription.deviceToken = deviceToken
//        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
//            //
//        }) { (response: QBResponse!) -> Void in
//            //
//        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
    }
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != [] {
            application.registerForRemoteNotifications()
        }
    }
            
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if #available(iOS 9.0, *) {
            var options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                                UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        } else {
            // Fallback on earlier versions
        }
        
        if ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        else if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        {
            return true
        } else {
            return false
        }
//        return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                    sourceApplication: sourceApplication,
//                                                    annotation: annotation)
    }
    
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
//        -> Bool {
//            return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
//    }
//    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if let invite = FIRInvites.handle(url, sourceApplication:sourceApplication, annotation:annotation) as? FIRReceivedInvite {
//            let matchType =
//                (invite.matchType == .weak) ? "Weak" : "Strong"
//            print("Invite received from: \(sourceApplication) Deeplink: \(invite.deepLink)," +
//                "Id: \(invite.inviteId), Type: \(matchType)")
//            return true
//        }
//        
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//    }
//    
    
    
    
    
    
    
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        
//        if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation){
//            return true
//        }
//        else if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        {
//            return true
//        }else {
//            return false
//        }
//    }
    
//    func application(application: UIApplication,
//                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
//    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        {
//            if (error == nil) {
//                // Perform any operations on signed in user here.
//                let userId = user.userID                  // For client-side use only!
//                let idToken = user.authentication.idToken // Safe to send to the server
//                let fullName = user.profile.name
//                let givenName = user.profile.givenName
//                let familyName = user.profile.familyName
//                let email = user.profile.email
//                // ...
//            } else {
//                print("\(error.localizedDescription)")
//            }
//        }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "A.Afters" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Afters", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

