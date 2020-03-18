//
//  WebService.swift
//  Afters
//
//  Created by C332268 on 18/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import Alamofire

class WebService: NSObject {
            
    class func postService(_ serviceName : String , objSelf:UIViewController, parameters:[String:AnyObject] , completion:@escaping (_ response:AnyObject)->()) {
        
        Alamofire.request(BASE_URL + serviceName, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON{ response in
                print(response)
                debugPrint(response)
                
                // Comment By Sourabh
                //                if response.result.value != nil {
                //
                //                    if (response.result.error == nil ) {
                //                        let mappedObject = mapper.map(JSON: response.result.value! as! [String : Any])
                //
                //                        if  mappedObject?.errorCode == 0
                //                        {
                //                            completion(mappedObject!)
                //                        } else
                //                        {
                //                            objSelf.showAlert("Info", message:mappedObject?.message )
                //                        }
                //                    } else {
                //                        objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                //                    }
                //                }
                
                // Written By Sourabh 
                switch response.result {
                    
                case .success(_):
                    if (response.result.value as? Dictionary<String, Any>) != nil {
                        do {
                            let basePartyModel = try JSONDecoder().decode(BasePartyModel.self, from: response.data ?? Data())
                            if basePartyModel.errorCode == 0 {
                                completion(basePartyModel)
                            } else {
                                objSelf.showAlert("Info", message: basePartyModel.message)
                            }
                        } catch let error {
                            print("post data error", error)
                        }
                    }
                case .failure(let error):
                    objSelf.showAlert("Error", message: error.localizedDescription)
                }
        }
    }
}
