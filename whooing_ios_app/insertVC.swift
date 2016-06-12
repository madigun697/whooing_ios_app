//
//  insertVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 5/5/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

class insertVC: UIViewController, UITextFieldDelegate, L_KeyboardDelegate, R_KeyboardDelegate {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var entry_date: UITextField!
    @IBOutlet var item_field: UITextField!
    @IBOutlet var money_field: UITextField!
    @IBOutlet var left_account: UITextField!
    @IBOutlet var right_account: UITextField!
    @IBOutlet var submit_btn: UIButton!
    
    @IBAction func submitEntry(sender: AnyObject) {

        var requiredFlag = false
        let alertTitle = "Required Value"
        var alertMsg:String = ""
        let okText = "OK"
        
        if (item_field.text == "") {
            alertMsg = "아이템은 필수값입니다."
            requiredFlag = true
        } else if (money_field.text == "") {
            alertMsg = "금액은 필수값입니다."
            requiredFlag = true
        } else if (left_account.text == "") {
            alertMsg = "좌측 항목은 필수값입니다."
            requiredFlag = true
        } else if (right_account.text == "") {
            alertMsg = "우측 항목은 필수값입니다."
            requiredFlag = true
        }
        
        if (requiredFlag) {
            let requiredAlert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okBtn = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            requiredAlert.addAction(okBtn)
            
            presentViewController(requiredAlert, animated: true, completion: nil)
            
            return
        }
        
        let l_account:String! = left_account.text
        let r_account:String! = right_account.text
        var item:String! = item_field.text
        
        print(item)
        
        if item.characters.last! == " " {
            item = item.substringToIndex(item.endIndex.predecessor())
        }
        
        let money:String! = money_field.text
        let memo:String! = ""
        var l_account_id:String! = ""
        var r_account_id:String! = ""
        
        let e_date:String! = entry_date.text!.stringByReplacingOccurrencesOfString("-", withString: "")
        
        let assets = accounts["assets"]
        var assetKeys = Array(assets!.keys)
        assetKeys.sortInPlace()
        let liabilities = accounts["liabilities"]
        var liabilitykeys = Array(liabilities!.keys)
        liabilitykeys.sortInPlace()
        let capitals = accounts["capital"]
        var capitalkeys = Array(capitals!.keys)
        capitalkeys.sortInPlace()
        let expenses = accounts["expenses"]
        var expensesKeys = Array(expenses!.keys)
        expensesKeys.sortInPlace()
        let income = accounts["income"]
        var incomeKeys = Array(income!.keys)
        incomeKeys.sortInPlace()
        
        if (l_account_id == "" || r_account_id == "") {
            for keys in assetKeys {
                if (l_account_id == "" && assets![keys]! == left_account.text) {
                    l_account_id = keys
                }
                
                if (r_account_id == "" && assets![keys]! == right_account.text) {
                    r_account_id = keys
                }
            }
            
            for keys in liabilitykeys {
                if (l_account_id == "" && liabilities![keys]! == left_account.text) {
                    l_account_id = keys
                }
                
                if (r_account_id == "" && liabilities![keys]! == right_account.text) {
                    r_account_id = keys
                }
            }
            
            for keys in capitalkeys {
                if (l_account_id == "" && capitals![keys]! == left_account.text) {
                    l_account_id = keys
                }
                
                if (r_account_id == "" && capitals![keys]! == right_account.text) {
                    r_account_id = keys
                }
            }
            
            for keys in expensesKeys {
                if (l_account_id == "" && expenses![keys]! == left_account.text) {
                    l_account_id = keys
                }
                
                if (r_account_id == "" && expenses![keys]! == right_account.text) {
                    r_account_id = keys
                }
            }
            
            for keys in incomeKeys {
                if (l_account_id == "" && income![keys]! == left_account.text) {
                    l_account_id = keys
                }
                
                if (r_account_id == "" && income![keys]! == right_account.text) {
                    r_account_id = keys
                }
            }
        }
        
        let api_name:String! = "entries.json"
        let params = ["section_id":section_id, "entry_date":e_date, "l_account":l_account,"l_account_id":l_account_id,"r_account":r_account,"r_account_id":r_account_id, "item":item, "money":money, "memo":memo]
        
        let req = makeReq(api_name, params: params)
        sendRequest(api_name, request: req)
        
        while (req_flag == false || req_api != api_name) {
            
        }
        
        if request_result!["code"] as! Int == 200  {
            self.performSegueWithIdentifier("unwindFromInsert", sender: self)
        }
        
        print(request_result!["code"] as! Int)
        
    }
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Variables of response
    var x_api_key:String?
    var user_id:String!
    var section_id:String!
    var accounts:[String:[String:String]]!
    var entries:[EntryVO]!
    var suggestions: [EntryVO]!
    
    var request_result:[String:AnyObject]?
    var req_api:String?
    var req_flag = true
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == entry_date {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.addTarget(self, action: #selector(insertVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        } else if (textField == left_account) {
            let assetKeyboard = AssetKeyboardView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            assetKeyboard.delegate = self
            assetKeyboard.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 260)
            
            textField.inputView = assetKeyboard
        } else if (textField == right_account) {
            let liabilityKeyboard = LiabilityKeyboardView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            liabilityKeyboard.delegate = self
            liabilityKeyboard.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 260)
            
            textField.inputView = liabilityKeyboard
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        entry_date.text = formatter.stringFromDate(sender.date)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // focused on next input field
        return true
    }
    
    func leftAccountKeyWasTapped(character: String) {
        left_account.text = character
    }
    
    func rightAccountKeyWasTapped(character: String) {
        right_account.text = character
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Making a request
    func makeReq(api_name:String, params:[String:String!] = [:]) -> NSMutableURLRequest {
        var req_urlStr:String! = "https://whooing.com/api/"
        var params_cnt:Int = 0
        req_urlStr = req_urlStr + api_name
        
        if (params.count > 0) {
            req_urlStr = req_urlStr + "?"
        }
        
        for (key, val) in params {
            params_cnt += 1
            if (val != "") {
                req_urlStr = "\(req_urlStr)\(key)=\(val!)"
                if (params_cnt != params.count) {
                    req_urlStr = "\(req_urlStr)&"
                }
            }
        }
        
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
//        x_api_key = "app_id=\(app_id),token=\(token),signiture=\(sha1),nounce=\(nounce),timestamp=\(timestamp)"
        
        let request_url = NSURL(string: req_urlStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting defaults values
        x_api_key = defaults.objectForKey("x_api_key") as? String
        user_id = defaults.objectForKey("user_id") as! String
        section_id = defaults.objectForKey("section_id") as! String
        entries = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("entries") as? NSData)!)! as! [EntryVO]
        suggestions = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("suggestions") as? NSData)!)! as! [EntryVO]
        accounts = defaults.objectForKey("accounts") as! [String:[String:String]]
        
        // Setting round corner of view
        popupView.layer.cornerRadius = 0.03 * popupView.bounds.size.width
        
        // declare delegate about text field
        entry_date.delegate = self
        left_account.delegate = self
        right_account.delegate = self
        
        // Setting default value in text field
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        entry_date.text = dateFormatter.stringFromDate(todaysDate)

    }
    
    
    
}