//
//  HostPartyHelper.swift
//  Afters
//
//  Created by C332268 on 19/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class HostPartyHelper: NSObject {
    
    class func rootDict() -> [String : Any]? {
        
        if let path = Bundle.main.path(forResource: "musicAndAge", ofType: "plist") {
            if let dict = NSDictionary.init(contentsOfFile: path) as? [String : Any] {
                return dict
            }
        }
        return nil
    }
    
    class func musicList() -> [String]? {
        if let dic = HostPartyHelper.rootDict(){
            return dic["music"] as? [String]
        }
        return nil
    }
    
    class func ageList() -> [String]? {
        if let dic = HostPartyHelper.rootDict() {
            return dic["AgeList"] as? [String]
        }
        return nil
    }
    
    class func genders() -> [String]? {
        if let dic = HostPartyHelper.rootDict() {
            return dic["Genders"] as? [String]
        }
        return nil
    }
    
    class func partyInfoModelToHostPartyModel(_ partyInfo : PartyInfo) -> HostPartyModel {
        let hostModel = HostPartyModel()
        hostModel.title = partyInfo.title ?? ""
        hostModel.desc = partyInfo.desc ?? ""
        hostModel.displayDate = partyInfo.dateOfParty ?? ""
        hostModel.music = partyInfo.music ?? ""        
        let dateString = partyInfo.dateOfParty
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if dateString != nil {
            let date = dateFormatter.date(from: dateString!)
            hostModel.time = (date?.timeStringFromDate())!
            hostModel.partyDate = (date?.newStringFromDate())!
            hostModel.partyTimeDate = date ?? Date()
        }
        let age = partyInfo.age ?? ""
        if age != ""{
            hostModel.age = age + "+"
        }
        hostModel.location = partyInfo.location ?? ""
        hostModel.attending = Int(partyInfo.attending!)!
        hostModel.host = Int(partyInfo.host!)!
        hostModel.latitude = Double(partyInfo.latitude!)!
        hostModel.longitude = Double(partyInfo.longitude!)!
        hostModel.image = partyInfo.image ?? ""
        hostModel.partyId = Int(partyInfo.partyId!)!
        return hostModel
    }
    
}
