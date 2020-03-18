//
//  FilterSelectionValue.swift
//  Afters
//
//  Created by Suyog Kolhe on 23/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class FilterSelectionValue: NSObject, NSCoding {

    var partyDate : Date = Date()
    var partyDateString = ""
    var radius  = 1000
    var music : String = ""
    var age : String = "0"
            
    // Chnges By Sourabh required init convert -> into required convenience init

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.partyDate = (aDecoder.decodeObject(forKey: "partyDate") as? Date)!
        if aDecoder.decodeObject(forKey: "partyDateString") != nil {
            self.partyDateString = (aDecoder.decodeObject(forKey: "partyDateString") as? String)!
        }
        if aDecoder.decodeObject(forKey: "radius") != nil {
            let radius = (aDecoder.decodeObject(forKey:"radius") as? String)!
            self.radius = Int(radius)!
            print (aDecoder.decodeObject(forKey: "radius")!)
        }
        if aDecoder.decodeObject(forKey: "music") != nil {
            self.music = (aDecoder.decodeObject(forKey:"music") as? String)!
        }
        if aDecoder.decodeObject(forKey: "age") != nil {
            self.age = (aDecoder.decodeObject(forKey: "age") as? String)!
        }
    }
    
     //Comment By Sourabh
//    required  init() {
//        super.init()
//    }
        
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.partyDate, forKey: "partyDate")
        aCoder.encode(self.partyDateString, forKey: "partyDateString")
        aCoder.encode(String(self.radius), forKey: "radius")
        aCoder.encode(self.music, forKey: "music")
        aCoder.encode(self.age, forKey: "age")
        print(self.radius)
    }

}
