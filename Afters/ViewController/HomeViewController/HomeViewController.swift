//
//  HomeViewController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK:-IBAction
extension HomeViewController {
    
    @IBAction func findPartyButtonClicked(_ sender: AnyObject) {
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        let navCtrl = tabBarController.viewControllers?[1] as! UINavigationController
        navCtrl.popToRootViewController(animated: false)
        partyType = .none
        tabBarController.canShowRightBarButton(true)
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func hostPartyButtonClicked(_ sender: AnyObject) {
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(false)
        let hostViewController = tabBarController.viewControllers?[2] as! HostViewController
        hostViewController.isEdit = false
        hostViewController.partyInfo = HostPartyModel()
        hostViewController.imageView = nil
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func editprofileButtonClicked(_ sender: AnyObject) {
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(false)
        let profileViewCtrl = self.tabBarController?.viewControllers?[3] as! ProfileViewController
        profileViewCtrl.editable = true
        self.tabBarController?.selectedIndex = 3
    }
}

//MARK:-UITableViewDelegate
extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }        
}







//Commenyted code

//
//    //MARK:- TableView Data Source And Delegate
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//
//        //
//        //        if (indexPath as NSIndexPath).row == 0 {
//        //
//        //            let cell : AddImageCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddImageCell
//        //
//        //            print("Cell +  \(cell)")
//        //
//        //            //            if uerinfo()?.fname != nil && uerinfo()?.lname != nil {
//        //            //                cell.userName!.text =  uerinfo()!.fname + " " + uerinfo()!.lname
//        //            //            }
//        //            //            if uerinfo()?.email != nil {
//        //            //            cell.emailId!.text =  uerinfo()!.email
//        //            //            }
//        //
//        //            return cell
//        //
//        //        }
//        //        // Configure the cell...
//        //        let cell : HostDetailCell = tableView.dequeueReusableCell(withIdentifier: "HostDetailCell", for: indexPath) as! HostDetailCell
//        //        cell.titleLabel?.text = arrayOfStrings[(indexPath as NSIndexPath).row]
//        ////        cell.icon?.image = UIImage(named: arrayOfIcons[(indexPath as NSIndexPath).row])
//        //        // Configure the cell...
//        //
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "Right Menu"
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
