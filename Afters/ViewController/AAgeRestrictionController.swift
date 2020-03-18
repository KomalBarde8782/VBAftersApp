//
//  AAgeRestrictionController.swift
//  Afters
//
//  Created by Suyog Kolhe on 06/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class AAgeRestrictionController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (UserDefaults.standard.object(forKey: "LoggedInUserInfo") as? NSData) != nil
        {
            self.loadRootViewController()
        }
    }
    
    @IBAction func exitApplication(_ sender: AnyObject) {
        //exit(0)
        //exit(-1)
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
        to: UIApplication.shared, for: nil)
        //Thread.main.cancel()
        //exit(EXIT_SUCCESS)
        //fatalError()
        //Thread.exit()
       // Thread.current.cancel()
        //abort()
    }
    
    private func loadRootViewController() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navCtrl = mainStoryBoard.instantiateViewController(withIdentifier: "NavigationController")
        let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NBPRootViewController") as! ARootViewController
        rootViewController.rootViewController = navCtrl
        let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.rootViewController = rootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}


