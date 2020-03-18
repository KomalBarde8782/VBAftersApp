//
//  CoreDataHelper.swift
//  Afters
//
//  Created by C332268 on 26/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import CoreData


enum PartyType {
    case none, myHosting, myAttending, myFavourites
}

var partyType : PartyType = .none

class CoreDataHelper: NSObject {
    
    class func savePartyInfo(_ parties: [PartyModelInfo]) {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        for partyInfo in parties {
            let managedContext = appDelegate.managedObjectContext
            //2
            let entity =  NSEntityDescription.entity(forEntityName: "PartyInfo",
                                                     in:managedContext)
            let partyInfoObject = PartyInfo(entity: entity!,
                                            insertInto: managedContext)
            //3
            partyInfoObject.setValue(String(partyInfo.title ?? ""), forKey: "title")
            partyInfoObject.setValue(String(partyInfo.host ?? ""), forKey: "host")
            //                    let date = NSDate.init(timeIntervalSince1970: NSTimeInterval(partyInfo.openTime))
            //                    let dateString =  NSDate.getDateString(date)
            //                    person.setValue(dateString, forKey: "dateTime")
            
            partyInfoObject.setValue(String(partyInfo.hostName ?? ""), forKey: "hostName")
            partyInfoObject.setValue(String(partyInfo.partyId ?? ""), forKey: "partyId")
            partyInfoObject.setValue(String(partyInfo.desc ?? ""), forKey: "desc")
            partyInfoObject.setValue(String(partyInfo.latitude ?? ""), forKey: "latitude")
            partyInfoObject.setValue(String(partyInfo.longitude ?? ""), forKey: "longitude")
            partyInfoObject.setValue(String(partyInfo.location ?? ""), forKey: "location")
            partyInfoObject.setValue(String(partyInfo.music ?? ""), forKey: "music")
            partyInfoObject.setValue(String(partyInfo.age ?? ""), forKey: "age")
            partyInfoObject.setValue(String(partyInfo.interest ?? ""), forKey: "interest")
            partyInfoObject.setValue(String(partyInfo.attending ?? ""), forKey: "attending")
            partyInfoObject.setValue(String(partyInfo.pdate ?? ""), forKey: "pdate")
            partyInfoObject.setValue(String(partyInfo.createdDate ?? ""), forKey: "createdDate")
            partyInfoObject.setValue(String(partyInfo.isFavourite ?? ""), forKey: "isFavourite")
            partyInfoObject.setValue(String(partyInfo.isLike ?? ""), forKey: "isLike")
            partyInfoObject.setValue(String(partyInfo.dateOfParty ?? ""), forKey: "dateOfParty")
            partyInfoObject.setValue(String(partyInfo.image ?? ""), forKey: "image")
            //4
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
        
    class func getParties() -> [PartyInfo] {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let  fetchRequest : NSFetchRequest<PartyInfo> = PartyInfo.fetchRequest() as! NSFetchRequest<PartyInfo>
        switch partyType {
        case .myHosting:
            fetchRequest.predicate = NSPredicate(format: "host == %@", String(LoginUserHelper.sharedInstance.userId()))
        case .myAttending:
            fetchRequest.predicate = NSPredicate(format: "isLike == %@", "1")
        case .myFavourites:
            fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", "1")
        default: break
        }
        let fetchedData = try! managedContext.fetch(fetchRequest)
        if (!fetchedData.isEmpty){
            print(fetchedData)
        }
        return fetchedData
    }
    
    class func deleteAllFrom(_ entity : String) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let  fetchRequest : NSFetchRequest<PartyInfo> = PartyInfo.fetchRequest() as! NSFetchRequest<PartyInfo>
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}
