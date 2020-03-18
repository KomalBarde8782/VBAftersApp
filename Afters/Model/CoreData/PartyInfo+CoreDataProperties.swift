//
//  PartyInfo+CoreDataProperties.swift
//  
//
//  Created by C332268 on 26/10/16.
//
//

import Foundation
import CoreData


extension PartyInfo {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<PartyInfo>(entityName: "PartyInfo") as! NSFetchRequest<NSFetchRequestResult>;
    }

    @NSManaged public var partyId: String?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var location: String?
    @NSManaged public var music: String?
    @NSManaged public var age: String?
    @NSManaged public var interest: String?
    @NSManaged public var attending: String?
    @NSManaged public var image: String?
    @NSManaged public var host: String?
    @NSManaged public var pdate: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var hostName: String?
    @NSManaged public var isFavourite: String?
    @NSManaged public var isLike: String?
    @NSManaged public var dateOfParty: String?

}
