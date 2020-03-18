//
//  TabBarController.swift
//  Afters
//
//  Created by Suyog Kolhe on 12/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet var saveButton : UIBarButtonItem!
    
    private let arrayOfImageNameForSelectedState = ["ic_home_white","ic_search_white","ic_add_white","ic_contacts_white"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]), for:.normal)
        let imageView = UIImageView.init(image: UIImage(named:"navBar_White_Icon"))
        self.navigationItem.titleView = imageView;
        saveButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Find" {
            partyType = .none
            let navCtrl = self.viewControllers?[1] as! UINavigationController
            let viewCtrl = navCtrl.viewControllers.first as! FindViewController
            navCtrl.popToRootViewController(animated: false)
            viewCtrl.reloadDataFromDataBase()
            self.saveButton.isEnabled = true
            self.navigationItem.rightBarButtonItem = saveButton
        } else {
            saveButton.isEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }
        if item.title == "Profile" {
            let profileViewCtrl = self.viewControllers?[3] as! ProfileViewController
            profileViewCtrl.editable = false
        }
        if item.title == "Host" {
            let profileViewCtrl = self.viewControllers?[2] as! HostViewController
            profileViewCtrl.partyInfo = HostPartyModel()
            profileViewCtrl.imageView = nil
            profileViewCtrl.isEdit = false
        }
    }
    
    public func canShowRightBarButton(_ canShow : Bool){
        if canShow == true {
            self.saveButton.isEnabled = true
            self.navigationItem.rightBarButtonItem = saveButton
        }else{
            saveButton.isEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func openLeftMenu(_ sender:UIBarButtonItem ) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewController().showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func rightButtonClicked(_ sender: AnyObject) {
        let searchFilterViewController : SearchFilterViewController = self.storyboard!.instantiateViewController(withIdentifier: "SearchFilterViewController") as! SearchFilterViewController
        let navCtrl = self.selectedViewController as! UINavigationController
        let viewCtrl = navCtrl.viewControllers.first as! FindViewController
        searchFilterViewController.delegate = viewCtrl
        navCtrl.view.addSubview(searchFilterViewController.view)
        navCtrl.addChild(searchFilterViewController)
        saveButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = nil
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
