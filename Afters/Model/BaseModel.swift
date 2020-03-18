//
//  BaseModel.swift
//  Afters
//
//  Created by Suyog Kolhe on 19/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


class BaseModel: Codable {

    var errorCode  = 0
    var message = ""
    var data : String?
    
    class func resolveDataInResponse<T:Decodable>(data:String,toModel:T.Type)->T? {
        let jsonDecoder = JSONDecoder()
        var userDataStruct:T? = nil
        
        do{
            let responseData: Data? = data.data(using: .utf8)
            userDataStruct = try jsonDecoder.decode(toModel, from:  responseData!)
        }catch{
            print("error in decoding")
            print(error.localizedDescription)
        }
        return userDataStruct
    }
    
    
    class func resolveDataInArrayResponse<T:Decodable>(data:String,toModel:[T].Type)->Array<Any>? {
        let jsonDecoder = JSONDecoder()
        var userDataStruct:Array<Any>?
        
        do{
            let responseData: Data? = data.data(using: .utf8)
            userDataStruct = try jsonDecoder.decode(toModel, from:  responseData!)
        }catch{
            print(error.localizedDescription)
        }
        return userDataStruct
    }
}

// Written By Sourabh 
class BasePartyModel: Codable {
    
    var errorCode  : Int?
    var message    : String?
    var data       : Int?
}
