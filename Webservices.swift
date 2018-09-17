//
//  Webservices.swift
//  Edumate_App
//
//  Created by Karthikeyan K. on 7/11/18.
//  Copyright © 2018 Itechind. All rights reserved.
//

import Foundation
import UIKit


typealias CompletionHandlerWithoutHeader  = (_ response:Any?, _ statusCode: Int?) -> Void


class Webservice{
    
    struct Shared{
        static let sharedinstance = Webservice()
    }
    
    class var webserviceinstance:Webservice{
        return Shared.sharedinstance
    }
    
        
    func getfunctionDetailsArray(url:URLRequest,parameters:NSDictionary,completion:@escaping CompletionHandlerWithoutHeader){
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 60
        urlconfig.timeoutIntervalForResource = 60
        let session = URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
//        session.dataTask(with: url) { (data, response, error) in
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil{
                    //                completion(data as Any,httpResponse.statusCode)
                    Alert.showWhileErrorOccurs(on: UIViewController())
                    activity.stopAnimating()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    Alert.showWhileErrorOccurs(on: UIViewController())
                    activity.stopAnimating()
                    return
                }
                
                switch httpResponse.statusCode{
                case 200:
                    do{
                        let value = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                        completion(value,httpResponse.statusCode)
                    }catch let error as Error {
                        print(error.localizedDescription)
                    }
                case 400:
                    completion(data as Any,httpResponse.statusCode)
                default:
                    completion(data as Any,httpResponse.statusCode)
                    break
                }
            }
            
        }.resume()
        
    }

}
