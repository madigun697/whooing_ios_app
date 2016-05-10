//
//  webAuthVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/19/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

class webAuthVC: UIViewController, UIWebViewDelegate {
    

    @IBOutlet var webView: UIWebView!
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Variables
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    var tmp_token:String?
    var pin:String?
    let app_secret:String = "90089d77732972d00733e622bbac5e2641d98013"
    let app_id:String = "186"
    
    // When web page loading is finished
    func webViewDidFinishLoad(webView: UIWebView) {
        // Current URL
        let curl = webView.request?.URL?.absoluteString
        
        // When ampersand is contained url, you have to find pin number through parsing url.
        let flag:Bool! = curl?.containsString("&")
        if (flag == true) {
            let parseUrl = curl?.componentsSeparatedByString("&")[1]
            let pinParam = parseUrl?.componentsSeparatedByString("=")
            
            if (pinParam![0] == "pin") {
                pin = pinParam![1]
                self.performSegueWithIdentifier("unwindFromWeb", sender: self)
            }
        }
    }
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Actions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var authUrlStr:String! = "https://whooing.com/app_auth/authorize?token="
        authUrlStr = authUrlStr + tmp_token!
        webView.loadRequest(NSURLRequest(URL: NSURL(string: authUrlStr)!))
        webView?.delegate = self
    }
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        About Segues
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! initVC
        destination.pin = pin!
    }
    
}