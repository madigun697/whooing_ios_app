//
//  insertVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 5/5/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation
import UIKit

class insertVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var entry_date: UITextField!
    @IBOutlet var left_account: UITextField!
    @IBOutlet var right_account: UITextField!
    
    var assetKeyboardView: UIView!
    var LiabilityKeyboardView: UIView!
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Variables of response
    var user_id:String!
    var section_id:String!
    var accounts:[String:[String:String]]!
    var assets:[String:String]!
    var assetKeys:[String]!
    var liabilitykeys:[String]!
    var liabilities:[String:String]!
    var entries:[EntryVO]!
    var suggestions: [EntryVO]!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == entry_date {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.addTarget(self, action: #selector(insertVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        } else if (textField == left_account) {
            if let objects = NSBundle.mainBundle().loadNibNamed("AssetKeyboardView", owner: self, options: nil) {
                assetKeyboardView = objects[0] as! UIView
            }
            textField.inputView = assetKeyboardView
        } else if (textField == right_account) {
            if let objects = NSBundle.mainBundle().loadNibNamed("LiabilityKeyboardView", owner: self, options: nil) {
                LiabilityKeyboardView = objects[0] as! UIView
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting defaults values
        user_id = defaults.objectForKey("user_id") as! String
        section_id = defaults.objectForKey("section_id") as! String
        accounts = defaults.objectForKey("accounts") as! [String:[String:String]]
        assets = accounts["assets"]
        assetKeys = Array(assets.keys)
        print(assets[assetKeys[2]])
        liabilities = accounts["liabilities"]
        liabilitykeys = Array(liabilities.keys)
        entries = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("entries") as? NSData)!)! as! [EntryVO]
        suggestions = NSKeyedUnarchiver.unarchiveObjectWithData((defaults.objectForKey("suggestions") as? NSData)!)! as! [EntryVO]
        
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