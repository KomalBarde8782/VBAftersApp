//
//  LoginResponseModel.swift
//  Afters
//
//  Created by Suyog Kolhe on 19/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

class LoginResponseModel: BaseModel {
    
    
    var dataObject : LoginUserInfo?
    
    // comment By Sourabh
//    override init() {
//        super.init()
//    }
//    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    //
    //    required init?(map: Map) {
    //        super.init(map: map)
    //    }
    //    // Mappable
    //    override func mapping(map: Map) {
    //        super.mapping(map: map)
    //        data    <- map["data"]
    //        dataObject = LoginUserInfo(json: data)
    //    }
}

// Newly Created Model
class LoginSocialInfo: Codable {
    var userId: String?
}

class LoginUserInfo: NSObject, Codable, NSCoding{
    
    func encode(with coder: NSCoder) {
    }
    
    required init?(coder: NSCoder) {
    }
    
    
    var userId : Int = 0
    var name : String = ""
    var email : String = ""
    var email2 : String = ""
    var phone : Int = 0
    var gender : String = ""
    var profileImage : String = ""
    var dob : String = ""
    var token : String?
    var emailNotify: Int = 0
    
}

    // Comment By Sourabh
//    required init(coder aDecoder: NSCoder) {
//
//        if aDecoder.decodeObject(forKey: "userId") != nil {
//            self.userId = (aDecoder.decodeObject(forKey: "userId") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "name") != nil {
//            self.name = (aDecoder.decodeObject(forKey: "name") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "email") != nil {
//            self.email = (aDecoder.decodeObject(forKey: "email") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "email2") != nil {
//            self.email2 = (aDecoder.decodeObject(forKey: "email2") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "phone") != nil {
//            self.phone = (aDecoder.decodeObject(forKey: "phone") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "gender") != nil {
//            self.gender = (aDecoder.decodeObject(forKey: "gender") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "profileImage") != nil {
//            self.profileImage = (aDecoder.decodeObject(forKey: "profileImage") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "dob") != nil {
//            self.dob = (aDecoder.decodeObject(forKey: "dob") as? String)!
//        }
//        if aDecoder.decodeObject(forKey: "token") != nil {
//            self.token = (aDecoder.decodeObject(forKey: "token") as? String)!
//        }
//
//    }
