//
//  BaseViewController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController , UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil;
        self.tabBarController?.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        let logo = UIImage(named: "navBar_White_Icon") as UIImage?
        let imageView = UIImageView(image:logo)
        imageView.frame.size.width = 200;
        imageView.frame.size.height = 45;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tabBarController != nil {
            let tabBarController : TabBarController = self.tabBarController as! TabBarController
            tabBarController.canShowRightBarButton(false)            
        }
    }
       
    open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Host"{
        } else {
            
        }
    }

    @IBAction func openLeftMenu(_ sender:UIBarButtonItem ) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewController().showLeftView(animated: true, completionHandler: nil)
    }
}

//MARK:-Local Functions
 extension UIViewController {
    
    @objc public func showActivity(){
//        MBProgressHUD.hide(for: self.view, animated: true)
//        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading"
       // Changes By Sourabh
        SVProgressHUD.dismiss()
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(UIColor.gray)
        SVProgressHUD.show(withStatus: "Loading")
    }
    
    @objc public func hideActivity() {
        //MBProgressHUD.hide(for: self.view, animated: true)
        // Changes By Sourabh
        SVProgressHUD.dismiss()
    }
    @objc  
    public func showAlert(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            print("showAlert")
        }
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: callActionHandler)
        alertView.addAction(defaultAction)
        alertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(alertView, animated: true, completion: nil)
    }
}
