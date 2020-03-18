//
//  ARootViewController.swift
//  Afters
//
//  Created by Suyog Kolhe on 09/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import LGSideMenuController
import GoogleMobileAds

class ARootViewController: LGSideMenuController , GADInterstitialDelegate {
    
    private var leftMenuController = LeftMenuController()
    private var interstitial: GADInterstitial!
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.initialSetUp()
        interstitial = createAndLoadInterstitial()
        timer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(ARootViewController.checkAndLoadInterstitialAd), userInfo: nil, repeats: true)
    }
    
    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.rightViewWillLayoutSubviews(with: size)
        if (!UIApplication.shared.isStatusBarHidden) {
            leftMenuController.tableView.frame = CGRect(x: 0.0 , y: 20.0, width: size.width, height: size.height-20.0);
        } else {
            leftMenuController.tableView.frame = CGRect(x: 0.0 , y: 0.0, width: size.width, height: size.height);
        }
    }
    
    internal func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1336083592322757/4344329429")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }
    
    internal func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }
    
    @objc func checkAndLoadInterstitialAd() {
        let purchased = UserDefaults.standard.bool(forKey: IAPIdentifier)
        let wantAd = UserDefaults.standard.bool(forKey: "KeepAdsClicked")
        if purchased {
            if wantAd {
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                }
            }
        } else {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    private func initialSetUp() {
        let navCtrl = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.rootViewController = navCtrl
        self.setupLeftAndRightMenu()
    }
    
    private func setupLeftAndRightMenu() {
        leftMenuController = self.storyboard!.instantiateViewController(withIdentifier: "LeftMenuController") as! LeftMenuController
        //self.setLeftViewEnabledWithWidth(250.0, presentationStyle:LGSideMenuPresentationStyle.slideBelow, alwaysVisibleOptions:LGSideMenuAlwaysVisibleOptions())
        self.leftViewWidth = 250.0
        self.leftViewPresentationStyle = .slideAbove
        self.leftViewBackgroundAlpha = 0.9
        self.leftViewStatusBarStyle = UIStatusBarStyle.default
//        //self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.onAll
//        //self.leftViewAlwaysVisibleOptions = .onAll
//        self.leftViewBackgroundColor = UIColor.clear
//        leftMenuController.tableView.backgroundColor = UIColor.white
//        self.leftViewBackgroundColor = UIColor.white
//        leftMenuController.tableView.reloadData()
//        self.leftView?.addSubview(leftMenuController.tableView)
        self.leftViewController = leftMenuController
//        leftView?.addSubview(leftMenuController.tableView)
    }
}


