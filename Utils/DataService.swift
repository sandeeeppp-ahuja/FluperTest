//
//  DataService.swift
//  FluperTest
//
//  Created by Sandeep on 7/12/20.
//  Copyright © 2020 SandMan. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    private init(){}
    static var instance = DataService()
    
    func getRequest(url:String, completion: @escaping (_ status:Bool, _ data:NSDictionary?) -> Void){
        AF.request(url, method: .get, encoding: JSONEncoding.default) .cURLDescription { description in
               print(description)
           }.responseJSON { response in
            var responseJSON = NSDictionary()
            do {
                try responseJSON =  response.result.get() as! NSDictionary
            } catch {
            }
            if response.response?.statusCode == 200 {
                completion(true, responseJSON)
            } else if response.response?.statusCode == 401 {
                completion(false, responseJSON)
            } else {
                completion(true, nil)
            }
        }
    }
    
}


