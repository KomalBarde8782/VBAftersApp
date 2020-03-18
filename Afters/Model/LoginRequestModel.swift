//
//  LoginRequestModel.swift
//  Afters
//
//  Created by C332268 on 18/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class LoginRequestModel: Codable {
    
    var email : String = ""
    var name : String = ""
    var phone : String = "7875888662"
    var gender : String = ""
    var profileImage : String = ""
    var dob : String?
    var token : String = ""
    var emailNotify  = "0"
    var password = ""
}

class EditProfileModel: Codable {
    
    var userId: Int?                         // Int
    var name : String = ""
    var email : String = ""
    var email2 = ""
    var phone : Int = 0                     //  Int
    var gender : String = ""
    var profileImage : String = ""
    //    var dob : String = "1994-01-20"
    var dob : String = ""
    var token : String = ""                          // String
    var emailNotify: Int = 0                 // Int  Bool
    
    var dateOfBirth: String? = ""
    var password: String? = ""
}

