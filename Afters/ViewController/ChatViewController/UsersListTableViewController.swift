//
//  UsersListTableViewController.swift
//  sample-chat-swift
//
//  Created by Injoit on 6/3/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class UsersListTableViewController: UITableViewController {
    
    var users : [QBUUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		

        // Fetching users from cache.
        ServicesManager.instance().usersService.loadFromCache().continue { [weak self] (task : BFTask!) -> AnyObject! in
            if task.result?.count > 0 {
				guard let users = ServicesManager.instance().sortedUsers() else {
					print("No cached users")
					return nil
				}
                self?.setupUsers(users)
                
            } else {
                
                SVProgressHUD.show(withStatus: "SA_STR_LOADING_USERS".localized, maskType: SVProgressHUDMaskType.clear)
                
                // Downloading users from Quickblox.
				
                ServicesManager.instance().downloadCurrentEnvironmentUsers({ (users: [QBUUser]?) -> Void in
					
					guard let unwrappedUsers = users else {
						SVProgressHUD.showError(withStatus: "No users downloaded")
						return
					}
					
                    SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
					
                    self?.setupUsers(unwrappedUsers)
                    
                    }, errorBlock: { (error: NSError!) -> Void in
                        
                        SVProgressHUD.showError(withStatus: error.localizedDescription)
                })
            }
            
            return nil;
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SA_STR_CELL_USER".localized, for: indexPath) as! UserTableViewCell
        
        let user = self.users[indexPath.row]
        
        cell.setColorMarkerText(String(indexPath.row + 1), color: ServicesManager.instance().color(forUser: user))
        cell.userDescription = user.fullName
        cell.tag = indexPath.row
        
        return cell
    }
    
    func setupUsers(_ users: [QBUUser]) {
        self.users = users
        self.tableView.reloadData()
    }
}
