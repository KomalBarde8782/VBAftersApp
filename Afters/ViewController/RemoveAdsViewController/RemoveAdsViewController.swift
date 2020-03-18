//
//  RemoveAdsViewController.swift
//  Afters
//
//  Created by C332268 on 12/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RemoveAdsViewController: BaseViewController {
    
    @IBOutlet weak var keepAdButton: UIButton!
    @IBOutlet weak var removeAddButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeAddButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(RemoveAdsViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    
    //MARK:- IBAction
    @IBAction func keppAdsButtonClicked(_ sender: Any) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootNavigationController().popViewController(animated: false)
    }
    
    @IBAction func removeAdButtonClicked(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "KeepAdsClicked")
        if let product = self.products.first {
            if RageProducts.store.isProductPurchased(product.productIdentifier) {
                self.removeAddButton.isHidden = true
                print("RageProducts.store.isProductPurchased")
            } else if IAPHelper.canMakePayments() {
                print("RageProducts.store.canMakePayments")
                RageProducts.store.buyProduct(product)
            } else {
                print("else")
            }
        }
    }
    
    //MARK:- Local Functions
    private func reload() {
        products = []
        RageProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                if self.products.count > 0{
                    self.removeAddButton.isHidden = false
                }
                print(self.products)
            }
        }
    }
    
    private func restoreTapped(_ sender: AnyObject) {
        RageProducts.store.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        for (_, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            self.removeAddButton.isHidden = true
        }
    }
}

// coomented code in view didload:
//            let purchased = UserDefaults.standard.bool(forKey: IAPIdentifier)
//            if purchased {
//
//                self.removeAddButton.isHidden = true
//                self.keepAdButton.isHidden = false
//            } else {
//                self.removeAddButton.isHidden = false
//                self.keepAdButton.isHidden = true
//            }

