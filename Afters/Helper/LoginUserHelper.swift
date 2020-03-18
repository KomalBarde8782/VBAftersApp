//
//  LoginUserHelper.swift
//  Afters
//
//  Created by C332268 on 20/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class LoginUserHelper {
    
    static let sharedInstance: LoginUserHelper = { LoginUserHelper() } ()
    
    public func userInfo() -> LoginUserInfo? {
        //commented by komal
        //        if let data = UserDefaults.standard.object(forKey: "LoggedInUserInfo") as? NSData
        //        {
        //            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! LoginUserInfo
        //            return decodedTeams
        //        }

        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "LoggedInUserInfo") as? Data else {return nil}
        // Use PropertyListDecoder to convert Data into LoginUserInfo
        guard let user = try? PropertyListDecoder().decode(LoginUserInfo.self, from: userData) else {return nil}
        print("user name is in login helper \(user.name)")
        return user
    }
    
    public func userId() ->Int {
        //commented by komal
        //                if let data = UserDefaults.standard.object(forKey: "LoggedInUserInfo") as? NSData{
        //                    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! LoginUserInfo
        //                    //            let email = UserDefaults.standard.value(forKey: "LoginUserEmail")
        //                    //            decodedTeams.email = email as! String
        //                    return decodedTeams.userId
        //                }
        //                return 0
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "LoggedInUserInfo") as? Data else {return 0}
        // Use PropertyListDecoder to convert Data into LoginUserInfo
        guard let user = try? PropertyListDecoder().decode(LoginUserInfo.self, from: userData) else {return 0}
        return user.userId        
    }
    
    public func profileInfo() -> EditProfileModel? {
        let profileInfo = EditProfileModel()
        profileInfo.email = UserDefaults.standard.value(forKey: "LoginUserEmail") as! String? ?? ""
        profileInfo.name = UserDefaults.standard.value(forKey: "LeftMenuProfileName") as! String? ?? ""
        profileInfo.profileImage = UserDefaults.standard.value(forKey: "LeftMenuProfileImage") as! String? ?? ""
        profileInfo.email2 = UserDefaults.standard.value(forKey: "LeftMenuProfileemail2") as! String? ?? ""
        return profileInfo
    }
}
