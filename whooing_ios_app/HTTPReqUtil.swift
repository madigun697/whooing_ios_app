//
//  HTTPReqUtil.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/22/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

class HTTPReqUtil: UIViewController {

var defaults = NSUserDefaults.standardUserDefaults()
var request_result:[String:AnyObject]?
var req_flag:Bool = false
var req_api:String = ""

// Making a request
func makeReq(api_name:String, params:[String:String] = [:], x_api_key:String) -> NSMutableURLRequest {
    var req_urlStr:String! = "https://whooing.com/api/"
    var params_cnt:Int = 0
    req_urlStr = req_urlStr + api_name
    
    if (params.count > 0) {
        req_urlStr = req_urlStr + "?"
    }
    
    for (val, key) in params {
        params_cnt++
        req_urlStr = "\(req_urlStr)\(key)=\(val)"
        if (params_cnt == params.count) {
            req_urlStr = "\(req_urlStr)&"
        }
    }
    
    let request_url = NSURL(string: req_urlStr)
    let request = NSMutableURLRequest(URL: request_url!)
    request.HTTPMethod = "GET"
    request.addValue(x_api_key, forHTTPHeaderField: "X-API-KEY")
    
    return request
}

// Sending Request
    func sendRequest(api_name: String, request: NSMutableURLRequest){
    do {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("Error -> \(error)")
                return
            }
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                let code = result!["code"] as! Int
                if code == 405 {
                    self.defaults.removeObjectForKey("access_token")
                    self.defaults.removeObjectForKey("token_secret")
                    self.defaults.removeObjectForKey("user_id")
                    
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                } else if code == 200 {
                    self.request_result = result
                } else {
                    print("Error Code -> \(code)")
                    print(result)
                }
                self.req_api = api_name
                self.req_flag = true
                print(self.req_api)
            } catch {
                print("Error -> \(error)")
            }
        }
        
        task.resume()
    }
}

}