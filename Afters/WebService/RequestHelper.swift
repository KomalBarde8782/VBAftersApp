//
//  RequestHelper.swift
//  Afters
//
//  Created by C332268 on 18/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class RequestHelper: NSObject {

    class func createRequest(_ object : AnyObject) -> [String: Any] {
        let userinfo = LoginUserHelper.sharedInstance
        //
        let user = userinfo.userInfo()
        //
        var userJson = [String : Any]()
        if user != nil {
            let email = user?.email
            let userId = user?.userId
            userJson = ["email":email! , "userId" : userId!]
        }
        // Comment By Sourabh
        //        let jsonString = object.toJsonString(ConversionOptions.DefaultSerialize)
        //        let loginRequest : [String : Any] = ["user" : userJson  , "data" : jsonString]
        //        print(loginRequest)
        //        //        let loginRequest = ["user" : userJson]
        //        return loginRequest
        
        // Written By Sourabh
        // Soution 1
        //        let encoder = JSONEncoder()
        //        encoder.outputFormatting = .prettyPrinted
        //
        //        let jsonString = try! encoder.encode(object)
        
        // Solution 2
        //        let mirror = Mirror(reflecting: object)
        //
        //        var paramsDict = [String:Any]()
        //        for child in mirror.children  {
        //            paramsDict.updateValue( child.value, forKey: child.label as! String)
        //            print("paramdict is :\(paramsDict)")
        //            // print("\(child.label),\(child.value)")
        //        }
        //        paramsDict.updateValue(<#T##value: Any##Any#>, forKey: <#T##String#>)
        
        // Solution 3
        //var loginRequest = Dictionary<String, Any>()
//        do {
//            if (!JSONSerialization.isValidJSONObject(object)) {
//                print("is not a valid json object")
//            }
//            //let encode = try JSONEncoder().encode(object)
//            //let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                loginRequest = ["user": userJson  , "data": jsonString]
//            }
//        } catch let error {
//            print("Error \(error.localizedDescription)")
//        }
        
        // Solution 4
        var loginRequest = Dictionary<String, Any>()
        // Convert Object into Dictionary
        let mirror = Mirror(reflecting: object)
        var paramsDict = [String:Any]()
        for child in mirror.children  {
            paramsDict.updateValue(child.value, forKey: child.label as! String)
            
        }
        // Convert Dictionary into Json String
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: paramsDict, options: .prettyPrinted)
            if let stringData = String(data: jsonData, encoding: .ascii) {
                loginRequest = ["user": userJson, "data": stringData]
            }
        } catch let error {
            print("Error \(error.localizedDescription)")
        }
        return loginRequest
    }
        
}
