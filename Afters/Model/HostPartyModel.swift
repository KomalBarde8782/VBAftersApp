//
//  HostPartyModel.swift
//  Afters
//
//  Created by C332268 on 19/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class HostPartyModel: Codable {

    var title : String = ""
    var desc: String = ""
    var displayDate: String = ""
    var partyDate : String = ""
    var time : String = ""
    var music : String = ""
    var age : String = ""
    var location  = ""
    var attending = 0
    var host = 0
    var interest = 0
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var pdate = 1476882240
    var image = ""
    var partyId = 0
    var partyTimeDate: Date?
    var selectedPartyDate: Date?
    
//     enum CodingKeys: String, CodingKey {
//        case title
//        case desc
//        case displayDate
//        case partyDate
//        case time
//        case music
//        case age
//        case location
//        case attending
//        case host
//        case interest
//        case latitude
//        case longitude
//        case pdate
//        case image
//        case partyId
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(title, forKey: .title)
//        try container.encode(displayDate, forKey: .displayDate)
//        try container.encode(desc, forKey: .desc)
//        try container.encode(partyDate, forKey: .partyDate)
//        try container.encode(time, forKey: .time)
//        try container.encode(music, forKey: .music)
//        try container.encode(age, forKey: .age)
//        try container.encode(location, forKey: .location)
//        try container.encode(attending, forKey: .attending)
//        try container.encode(host, forKey: .host)
//        try container.encode(interest, forKey: .interest)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//        try container.encode(pdate, forKey: .pdate)
//        try container.encode(image, forKey: .image)
//        try container.encode(partyId, forKey: .partyId)
//    }
}

// Written By Sourabh
class HostPartResponse: Codable {
    var errorCode: Int?
    var message: String?
    var data: Int?
}
