//
//  mainVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/25/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var asLocaleCurrency:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return formatter.stringFromNumber(self)!
    }
}

class mainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, Dimmable {
    
    @IBOutlet var entryTable: UITableView!
    @IBOutlet var bsView: UIView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(mainVC.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    // Bar Graph
    @IBOutlet var asset_bar: UIView!
    @IBOutlet var liabilities_bar: UIView!
    
    // Underline
    @IBOutlet var asset_underline: UIView!
    @IBOutlet var liabilities_underline: UIView!
    
    // Labels
    @IBOutlet var bs_date: UILabel!
    @IBOutlet var liabilities_label: UILabel!
    @IBOutlet var asset_1: UILabel!
    @IBOutlet var asset_2: UILabel!
    @IBOutlet var asset_3: UILabel!
    @IBOutlet var liabilities_1: UILabel!
    @IBOutlet var liabilities_2: UILabel!
    @IBOutlet var liabilities_3: UILabel!
    @IBOutlet var a_money_1: UILabel!
    @IBOutlet var a_money_2: UILabel!
    @IBOutlet var a_money_3: UILabel!
    @IBOutlet var l_money_1: UILabel!
    @IBOutlet var l_money_2: UILabel!
    @IBOutlet var l_money_3: UILabel!
    @IBOutlet var total_asset_money: UILabel!
    @IBOutlet var total_liabilities_money: UILabel!
    
    // Circular Button
    @IBOutlet var plus_btn: UIButton!

/*
-----------------------------------------------------------------------------------------------------------------------------------------
    UI Actions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    @IBAction func new_entry(sender: AnyObject) {
        
    }
    
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
    Variables
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    // Application's defaults variables
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Variables of response
    var user_id:String!
    var section_id:String = ""
    var accounts:[String:[String:String]]!
    var entries: [EntryVO] = []
    var suggestions: [EntryVO] = []
    var x_api_key:String?
    
    var request_result:[String:AnyObject]?
    var req_api:String?
    var req_flag = true
    
    // Variables of B/S
    var lastBSLoadingDate:String = ""
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
        // Hide navigationbar
        self.navigationController?.navigationBarHidden = true
        
        // Set background image
        self.asset_bar.backgroundColor = UIColor(patternImage: UIImage(named: "asset_bar.png")!)
        self.liabilities_bar.backgroundColor = UIColor(patternImage: UIImage(named: "liabilities_bar.png")!)
        self.asset_underline.backgroundColor = UIColor(patternImage: UIImage(named: "asset_underline.png")!)
        self.liabilities_underline.backgroundColor = UIColor(patternImage: UIImage(named: "liabilities_underline.png")!)
        
        // Getting all defaults values
        defaults.setObject(view.frame.width, forKey: "screenWidth")
        
        user_id = defaults.objectForKey("user_id") as! String
        section_id = defaults.objectForKey("section_id") as! String
        accounts = defaults.objectForKey("accounts") as! [String:[String:String]]
        x_api_key = defaults.objectForKey("x_api_key") as? String
        
        suggestions = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("suggestions") as? NSData)!)! as! [EntryVO]
        
        entryTable.delegate = self
        entryTable.dataSource = self
        
        self.entryTable.addSubview(self.refreshControl)
        
        lastBSLoadingDate = defaults.objectForKey("lastBSLoadingDate") as! String
        
        total_assets = defaults.objectForKey("total_assets") as! Int
        total_liabilities = defaults.objectForKey("total_liabilities") as! Int
        total_capital = defaults.objectForKey("total_capital") as! Int
        bs_assets = defaults.objectForKey("bs_assets") as! [String:Int]
        bs_liabilities = defaults.objectForKey("bs_liabilities") as! [String:Int]
        
        // Set Label Text in B/S
        bs_date.text = "Last Refresh \(defaults.objectForKey("lastBSLoadingDate")!)"
        
        var asset_cnt = 0;
        var liabilities_cnt = 0;
        
        for s in suggestions {
            print("\(accounts[s.l_account!]![s.l_account_id!]!), \(accounts[s.r_account!]![s.r_account_id!]!), \(s.r_account_id)")
        }
        
        for s in suggestions {
            let l_name = accounts[s.l_account!]![s.l_account_id!]!
            let r_name = accounts[s.r_account!]![s.r_account_id!]!
            
            if (s.l_account == "assets" && asset_cnt == 0) {
                asset_1.text = l_name
                a_money_1.text = "\(bs_assets[s.l_account_id!]!.asLocaleCurrency)"
                asset_cnt += 1
            } else if (s.l_account == "assets" && asset_cnt == 1 && asset_1.text != l_name) {
                asset_2.text = l_name
                a_money_2.text = "\(bs_assets[s.l_account_id!]!.asLocaleCurrency)"
                asset_cnt += 1
            } else if (s.l_account == "assets" && asset_cnt == 2 && asset_1.text != l_name && asset_2.text != l_name) {
                asset_3.text = l_name
                a_money_3.text = "\(bs_assets[s.l_account_id!]!.asLocaleCurrency)"
                asset_cnt += 1
            } else if (s.r_account == "liabilities" && liabilities_cnt == 0) {
                liabilities_1.text = r_name
                l_money_1.text = "\(bs_liabilities[s.r_account_id!]!.asLocaleCurrency)"
                liabilities_cnt += 1
            } else if (s.r_account == "liabilities" && liabilities_cnt == 1 && liabilities_1.text != r_name) {
                liabilities_2.text = r_name
                l_money_2.text = "\(bs_liabilities[s.r_account_id!]!.asLocaleCurrency)"
                liabilities_cnt += 1
            } else if (s.r_account == "liabilities" && liabilities_cnt == 2 && liabilities_1.text != r_name && liabilities_2.text != r_name) {
                liabilities_3.text = r_name
                l_money_3.text = "\(bs_liabilities[s.r_account_id!]!.asLocaleCurrency)"
                liabilities_cnt += 1
            } else if (asset_cnt == 3 && liabilities_cnt == 3) {
                break
            }
        }
        
        total_asset_money.text = "Total: \(total_assets.asLocaleCurrency)"
        total_liabilities_money.text = "Total: \(total_liabilities.asLocaleCurrency)"
        
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Cricular buttion shape setting
        plus_btn.layer.cornerRadius = 0.5 * plus_btn.bounds.size.width

        // Calculate graph size
        var asset_width:CGFloat = 0.0
        var liabilities_width:CGFloat = 0.0
        
        if (total_assets > total_liabilities) {
            asset_width = 0.9
            liabilities_width = CGFloat(total_liabilities) / CGFloat(total_assets)
        } else {
            liabilities_width = 0.9
            asset_width = CGFloat(total_assets) / CGFloat(total_liabilities)
        }
        
        // Resizing frames
        self.bsView.frame = CGRect(x: bsView.frame.origin.x, y: bsView.frame.origin.y, width: screenSize.width, height: bsView.frame.height)
        
        self.asset_bar.frame = CGRect(x: asset_bar.frame.origin.x, y: asset_bar.frame.origin.y, width: (screenSize.width * 0.5 - 10) * asset_width, height: asset_bar.frame.height)
        
        self.liabilities_bar.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_bar.frame.origin.y, width: (screenSize.width * 0.5 - 10) * liabilities_width, height: liabilities_bar.frame.height)
        
        self.liabilities_label.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_label.frame.origin.y, width: liabilities_label.frame.width, height: liabilities_label.frame.height)
        self.liabilities_underline.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_underline.frame.origin.y, width: liabilities_underline.frame.width, height: liabilities_underline.frame.height)
        self.liabilities_1.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_1.frame.origin.y, width: liabilities_1.frame.width, height: liabilities_1.frame.height)
        self.liabilities_2.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_2.frame.origin.y, width: liabilities_2.frame.width, height: liabilities_2.frame.height)
        self.liabilities_3.frame = CGRect(x: screenSize.width * 0.5 + 10, y: liabilities_3.frame.origin.y, width: liabilities_3.frame.width, height: liabilities_3.frame.height)
        self.total_liabilities_money.frame = CGRect(x: screenSize.width * 0.5 + 10, y: total_liabilities_money.frame.origin.y, width: total_liabilities_money.frame.width, height: total_liabilities_money.frame.height)
        
        entries = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("entries") as? NSData)!)! as! [EntryVO]
        
        handleRefresh(refreshControl)
        
        
        super.viewDidAppear(false)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let entryCell = entryTable.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! entryTableViewCell
        let entry = entries[indexPath.row]
        
        entryCell.cellDateLabel.text = entry.entry_date!
        var l_account_list = accounts![entry.l_account!]
        var r_account_list = accounts![entry.r_account!]
        entryCell.cellAccountLabel.text = "\(l_account_list![entry.l_account_id!]!) > \(r_account_list![entry.r_account_id!]!)"
        entryCell.cellTitleLabel.text = entry.entry_title!
        entryCell.cellMoneyLabel.text = "\(entry.money!.asLocaleCurrency)원"
        
        return entryCell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let idx = indexPath.row
            print(idx)
            let api_name:String! = "entries/\(self.entries[idx].entry_id!).json"
            let req = self.makeReq(api_name)
            self.sendRequest(api_name, request: req)
            
            while (self.req_flag == false || self.req_api != api_name) {
                
            }
            
            if self.request_result!["code"] as! Int == 200 {
                
                self.entries.removeAtIndex(idx)
                self.defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.entries), forKey: "entries")
                
            }
            
            self.handleRefresh(self.refreshControl)
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        
        return [deleteAction]
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        entries = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("entries") as? NSData)!)! as! [EntryVO]
        
        self.entryTable.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromInsert(segue: UIStoryboardSegue) {
        
        handleRefresh(refreshControl)
        dim(.Out, speed: dimSpeed)
    }
    
    
    // Making a request
    func makeReq(api_name:String) -> NSMutableURLRequest {
        var req_urlStr:String! = "https://whooing.com/api/"
        req_urlStr = req_urlStr + api_name
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let rangeOfTimestampInXAPIKEY = Range(start: (x_api_key?.rangeOfString("timestamp")?.endIndex.advancedBy(1))!, end: (x_api_key?.endIndex)!)
        x_api_key?.replaceRange(rangeOfTimestampInXAPIKEY, with: "\(timestamp)")
        
        let request_url = NSURL(string: req_urlStr)
        let request = NSMutableURLRequest(URL: request_url!)
        request.HTTPMethod = "DELETE"
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

}