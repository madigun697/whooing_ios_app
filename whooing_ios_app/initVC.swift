//
//  initVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/19/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Header for SHA1
-----------------------------------------------------------------------------------------------------------------------------------------
*/

extension String {
    func sha1() -> String {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}

class initVC: UIViewController, Dimmable {
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Variables
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    // Prepare url, app informations and token variables
    // For getting temporary token
    let app_secret:String = "90089d77732972d00733e622bbac5e2641d98013"
    let app_id:String = "186"
    let urlStr:String = "https://whooing.com/app_auth/request_token"
    var tmp_token:String = ""
    
    // For getting access token
    var pin:String = ""
    var token:String = ""
    var token_secret:String! = ""
    var user_id:String! = ""
    var req_flag = true
    
    // request api key
    var x_api_key:String?
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Actions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    // Checking access token when application start
    // If application doesn't have access token, Request temporary token
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.objectForKey("access_token") == nil {
            getTmpToken()
            while (tmp_token == "") {}
        }
    }
    
    // If application doesn't have access token, Request web view w/ temporary token
    // If application has access token, Go to mainVC
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if (defaults.objectForKey("access_token") != nil && defaults.objectForKey("access_token") as! String == "") {
            self.defaults.removeObjectForKey("access_token")
            self.defaults.removeObjectForKey("token_secret")
            self.defaults.removeObjectForKey("user_id")
            
        }
        
        if (defaults.objectForKey("access_token") != nil) {

            token = defaults.objectForKey("access_token") as! String
            token_secret = defaults.objectForKey("token_secret") as! String
            user_id = defaults.objectForKey("user_id") as! String

            makeXAPIKey()
            while(x_api_key == "") {}
            
            goLoading()
        } else {
            self.performSegueWithIdentifier("authSegue", sender: self)
        }
        
    }
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        About Segues
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    // Before move to webAuthVC, transfer temporary token
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Branch where to go
        if (segue.identifier == "authSegue") {

            // When move to webAuthVC, transfer temporary token
            let destination = segue.destinationViewController as! webAuthVC
            destination.tmp_token = tmp_token;
            dim(.In, alpha: dimLevel, speed: dimSpeed)
            
            
        } else if (segue.identifier == "loadingSegue") {
            
            // When move to loadingVC, transfer user_id & x_api_key
            let destination = segue.destinationViewController as! loadingVC
            destination.user_id = user_id
            destination.x_api_key = x_api_key
            
        }
    }
    
    // When webAuthVC unwind, Request access token w/ temporary token and pin number
    @IBAction func unwindFromWeb(segue: UIStoryboardSegue) {
        getToken()
        
        while(token == "") {}
        
        defaults.setObject(token, forKey: "access_token")
        defaults.setObject(token_secret, forKey: "token_secret")
        defaults.setObject(user_id, forKey: "user_id")
        
        makeXAPIKey()
        while(x_api_key == "") {}
        
        goLoading()
        
        dim(.Out, speed: dimSpeed)
    }
    
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Functions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    
    // Getting a temporary token
    func getTmpToken(){
        
        do {
            let url = NSURL(string: "\(urlStr)?app_secret=\(app_secret)&app_id=\(app_id)")
            let request = NSMutableURLRequest(URL: url!)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                if error != nil {
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:String]
                    let t:String! = result!["token"]
                    self.tmp_token = t
                    self.req_flag = false
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        }
        
    }
    
    // Getting a access token
    func getToken(){
        
        do {
//            print("https://whooing.com/app_auth/access_token?app_id=\(app_id)&app_secret=\(app_secret)&token=\(tmp_token)&pin=\(pin)")
            let url = NSURL(string: "https://whooing.com/app_auth/access_token?app_id=\(app_id)&app_secret=\(app_secret)&token=\(tmp_token)&pin=\(pin)")
            let request = NSMutableURLRequest(URL: url!)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                if error != nil {
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:String]
                    self.token = result!["token"]!
                    self.token_secret = result!["token_secret"]
                    self.user_id = result!["user_id"]
                    
                    print("Get Token() :: Token -> \(self.token), Token Secret -> \(self.token_secret), User Id -> \(self.user_id)")
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        }
        
    }
    
    // Make X-API-Key
    func makeXAPIKey() {
        var sha1:String = app_secret + "|" + token_secret!
        sha1 = sha1.sha1()
        
        var nounce = NSUUID().UUIDString
        nounce = nounce.stringByReplacingOccurrencesOfString("-", withString: "")
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        while (token == "") {}
        
        x_api_key = "app_id=\(app_id),token=\(token),signiture=\(sha1),nounce=\(nounce),timestamp=\(timestamp)"
        
        defaults.setObject(x_api_key, forKey: "x_api_key")
    }
    
    // Move to LoadingVC
    func goLoading() {
        performSegueWithIdentifier("loadingSegue", sender: self)
    }
    

    
}
