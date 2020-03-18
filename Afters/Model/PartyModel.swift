//
//  PartyModel.swift
//  Afters
//
//  Created by Suyog Kolhe on 23/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class PartyModel: BaseModel {

    var dataObject : [PartyModelInfo]?
    
//    override init(){
//        super.init()
//    }
//    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    // Comment By Sourabh 
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//    // Mappable
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        data    <- map["data"]
//        if data != nil{
//        dataObject = [PartyModelInfo](json: data!)
//        }
//    }
    
}

class PartyModelInfo: Codable {
    
    var partyId : String?
    var title : String?
    var desc : String?
    var latitude : String?
    var longitude : String?
    var location : String?
    var music : String?
    var age : String?
    var interest : String?
    var attending : String?
    var image : String?
    var host : String?
    var pdate : String?
    var createdDate : String?
    var hostName : String?
    var isFavourite : String?
    var isLike : String?
    var dateOfParty : String?
    
//    
//    required init?(map: Map) {
//        
//    }
//    
//    init(){
//        
//    }
//    
//    
//     func mapping(map: Map) {
//        
//        partyId     <- map["partyId"]
//        title       <- map["title"]
//        desc        <- map["desc"]
//        latitude    <- map["latitude"]
//        longitude   <- map["longitude"]
//        location    <- map["location"]
//        music       <- map["music"]
//        age         <- map["age"]
//        interest    <- map["interest"]
//        attending   <- map["attending"]
//        image       <- map["image"]
//        host        <- map["host"]
//        pdate       <- map["pdate"]
//        createdDate <- map["createdDate"]
//        hostName    <- map["hostName"]
//        isFavourite <- map["isFavourite"]
//        isLike      <- map["isLike"]
//        dateOfParty <- map["dateOfParty"]
//    }
//    

}
