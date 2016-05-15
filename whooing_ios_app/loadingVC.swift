//
//  loadingVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/24/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

class loadingVC: UIViewController {
    
    @IBOutlet var loadingLabel: UITextField!
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Variables
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    // Variables for request
    let defaults = NSUserDefaults.standardUserDefaults()
    var x_api_key:String?
    var request_result:[String:AnyObject]?
    var req_api:String?
    var req_flag = true
    var cur_date:String!
    
    // Variables of response
    var user_id:String!
    var section_id:String = ""
    var accounts:[String:[String:String]]?
    var entries = [EntryVO]()
    var suggestions = [EntryVO]()
    
    // Variables of B/S
    var total_assets:Int = 0
    var total_liabilities:Int = 0
    var total_capital:Int = 0
    var bs_assets:[String:Int] = [:]
    var bs_liabilities:[String:Int] = [:]
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Actions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        loadingLabel.text = "Getting default section"
        self.getDefaultSection()

        loadingLabel.text = "Getting account information"
        self.getAccountInfo()

        loadingLabel.text = "Getting history"
        self.getHistory()
        self.getSuggestion()
        
        
        // Check exist B/S
        if (defaults.objectForKey("bs_assets") != nil) {
            total_assets = defaults.objectForKey("total_assets") as! Int
            total_liabilities = defaults.objectForKey("total_assets") as! Int
            total_capital = defaults.objectForKey("total_assets") as! Int
            bs_assets = defaults.objectForKey("bs_assets") as! [String:Int]
            bs_liabilities = defaults.objectForKey("bs_assets") as! [String:Int]
        }
        
//        self.getBS()
        
        if (bs_assets.count == 0 || defaults.objectForKey("lastBSLoadingDate") == nil) {
            loadingLabel.text = "Getting Balance Sheet"
            self.getBS()
        }
        
        // go to mainVC
        goToMain()
    }

    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Functions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    func goToMain() {
        defaults.setObject(user_id, forKey: "user_id")
        defaults.setObject(section_id, forKey: "section_id")
        defaults.setObject(accounts, forKey: "accounts")
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(entries), forKey: "entries")
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(suggestions), forKey: "suggestions")

        performSegueWithIdentifier("mainSegue", sender: self)
    }
    
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
        Functions of API
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    
    // Making a request
    func makeReq(api_name:String, params:[String:String] = [:]) -> NSMutableURLRequest {
        var req_urlStr:String! = "https://whooing.com/api/"
        var params_cnt:Int = 0
        req_urlStr = req_urlStr + api_name
        
        if (params.count > 0) {
            req_urlStr = req_urlStr + "?"
        }
        
        for (val, key) in params {
            params_cnt += 1
            req_urlStr = "\(req_urlStr)\(key)=\(val)"
            if (params_cnt == params.count) {
                req_urlStr = "\(req_urlStr)&"
            }
        }
        
        let request_url = NSURL(string: req_urlStr)
        let request = NSMutableURLRequest(URL: request_url!)
        request.HTTPMethod = "GET"
        request.addValue(x_api_key!, forHTTPHeaderField: "X-API-KEY")
        
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
    
    // Getting default section id
    func getDefaultSection() {
        let api_name:String! = "sections/default.json"
        let req = makeReq(api_name)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        section_id = (request_result!["results"])!["section_id"] as! String
        req_flag = false
    }
    
    // Getting account informations
    func getAccountInfo() {
        let api_name:String! = "accounts.json_array"
        let params = [section_id:"section_id"]
        let req = makeReq(api_name, params: params)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        //        'assets' : 자산
        //        'liabilities' : 부채
        //        'capital' : 순자산
        //        'expenses' : 비용
        //        'income' : 수익
        
        var assets:[String:String] = [:]
        var liabilities:[String:String] = [:]
        var capital:[String:String] = [:]
        var expenses:[String:String] = [:]
        var income:[String:String] = [:]
        
        var tmp_result = (request_result!["results"])!["assets"] as! [[String:AnyObject]]
        
        for tmp in tmp_result {
            assets[tmp["account_id"] as! String] = (tmp["title"] as! String)
        }
        
        tmp_result = (request_result!["results"])!["liabilities"] as! [[String:AnyObject]]
        
        for tmp in tmp_result {
            liabilities[tmp["account_id"] as! String] = (tmp["title"] as! String)
        }
        
        tmp_result = (request_result!["results"])!["capital"] as! [[String:AnyObject]]
        
        for tmp in tmp_result {
            capital[tmp["account_id"] as! String] = (tmp["title"] as! String)
        }
        
        tmp_result = (request_result!["results"])!["expenses"] as! [[String:AnyObject]]
        
        for tmp in tmp_result {
            expenses[tmp["account_id"] as! String] = (tmp["title"] as! String)
        }
        
        tmp_result = (request_result!["results"])!["income"] as! [[String:AnyObject]]
        
        for tmp in tmp_result {
            income[tmp["account_id"] as! String] = (tmp["title"] as! String)
        }
        
        accounts = ["assets" : assets, "liabilities" : liabilities, "capital" : capital, "expenses" : expenses, "income" : income]
        
    }
    
    
    // Getting transaction history
    func getHistory() {
        let api_name:String! = "entries/latest.json"
        let params = [section_id:"section_id"]
        let req = makeReq(api_name, params: params)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        let hist = request_result!["results"] as! [[String:AnyObject]]
        
        for h in hist {
            let entry:EntryVO = EntryVO()
            let tmp_date = h["entry_date"] as! String
            
            entry.entry_date = "\(tmp_date.substringWithRange(Range(start: tmp_date.startIndex, end: tmp_date.startIndex.advancedBy(4))))-\(tmp_date.substringWithRange(Range(start: tmp_date.startIndex.advancedBy(4), end: tmp_date.startIndex.advancedBy(6))))-\(tmp_date.substringWithRange(Range(start: tmp_date.startIndex.advancedBy(6), end: tmp_date.startIndex.advancedBy(8))))"
            
            entry.entry_title = (h["item"] as! String)
            entry.money = (h["money"] as! Int)
            entry.l_account = (h["l_account"] as! String)
            entry.l_account_id = (h["l_account_id"] as! String)
            entry.r_account = (h["r_account"] as! String)
            entry.r_account_id = (h["r_account_id"] as! String)
            entries.append(entry)
        }
        
        req_flag = false
    }
    
    // Getting Balance Sheet
    func getBS() {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cur_date = dateFormatter.stringFromDate(todaysDate)
        print(cur_date)
        
        defaults.setObject(cur_date, forKey: "lastBSLoadingDate")
        
        let api_name:String! = "bs.json_array"
        let params = [section_id:"section_id", cur_date:"end_date"]
        let req = makeReq(api_name, params: params)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        //        'assets' : 자산
        //        'liabilities' : 부채
        //        'capital' : 순자산
        
        let tmp_result = (request_result!["results"])
        
        total_assets = tmp_result!["assets"]!!["total"] as! Int
        total_liabilities = tmp_result!["liabilities"]!!["total"] as! Int
        total_capital = tmp_result!["capital"]!!["total"] as! Int
        
        let assets = tmp_result!["assets"]!!["accounts"] as! [[String:AnyObject]]
     
        for a in assets {
            bs_assets[a["account_id"] as! String] = (a["money"] as! Int)
        }
        
        let liabilities = tmp_result!["liabilities"]!!["accounts"] as! [[String:AnyObject]]
        
        for l in liabilities {
            bs_liabilities[l["account_id"] as! String] = (l["money"] as! Int)
        }
        
        defaults.setObject(total_assets, forKey: "total_assets")
        defaults.setObject(total_liabilities, forKey: "total_liabilities")
        defaults.setObject(total_capital, forKey: "total_capital")
        defaults.setObject(bs_assets, forKey: "bs_assets")
        defaults.setObject(bs_liabilities, forKey: "bs_liabilities")
        
        for l in bs_liabilities {
            print(l)
        }

    }

    // Getting lastest entry(suggestion)
    func getSuggestion() {
        let api_name:String! = "entries/latest_items.json"
        let params = [section_id:"section_id"]
        let req = makeReq(api_name, params: params)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        let hist = request_result!["results"] as! [[String:AnyObject]]
        
        for h in hist {
            let entry:EntryVO = EntryVO()
            entry.entry_title = (h["item"] as! String)
            entry.money = (h["money"] as! Int)
            entry.l_account = (h["l_account"] as! String)
            entry.l_account_id = (h["l_account_id"] as! String)
            entry.r_account = (h["r_account"] as! String)
            entry.r_account_id = (h["r_account_id"] as! String)
            suggestions.append(entry)
        }
        
        req_flag = false
    }
    
}