//
//  Constants.swift
//  Afters
//
//  Created by C332268 on 18/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


var BASE_URL:String = "http://aftersapp.com/api/"

var IAPIdentifier : String = "com.christopher.aftersApp.RemoveAds"

let kChatPresenceTimeInterval:TimeInterval = 45
let kDialogsPageLimit:UInt = 100
let kMessageContainerWidthPadding:CGFloat = 40.0


/*  ServicesManager
	...
	func downloadLatestUsers(successBlock:(([QBUUser]?) -> Void)?, errorBlock:((NSError) -> Void)?) {
	
	let enviroment = Constants.QB_USERS_ENVIROMENT
	
	self.usersService.searchUsersWithTags([enviroment])
	*/
class Constants {
    
    class var QB_USERS_ENVIROMENT: String {
        
        #if DEBUG
            return "dev"
        #elseif QA
            return "qbqa"
        #else
            assert(false, "Not supported build configuration")
            return ""
        #endif
        
    }
}
