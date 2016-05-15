//
//  AssetKeyboardView.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 5/15/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func leftAccountKeyWasTapped(character: String)
}

class AssetKeyboardView: UIView {
    
    @IBOutlet var tBtn: UIButton!
    @IBOutlet var assetLabel: UILabel!
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var accounts:[String:[String:String]]!
    var assets:[String:String]!
    var assetKeys:[String]!
    var liabilitykeys:[String]!
    var liabilities:[String:String]!
    var capital:[String:String]!
    var capitalKeys:[String]!
    var expenses:[String:String]!
    var expensesKeys:[String]!
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: KeyboardDelegate?
    
    // MARK:- keyboard initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        
        let xibFileName = "AssetKeyboardView" // xib extention not included
        let view = NSBundle.mainBundle().loadNibNamed(xibFileName, owner: self, options: nil)[0] as! UIView
        
        tBtn.hidden = true
        
        accounts = defaults.objectForKey("accounts") as! [String:[String:String]]
        assets = accounts["assets"]
        assetKeys = Array(assets.keys)
        assetKeys.sortInPlace()
        liabilities = accounts["liabilities"]
        liabilitykeys = Array(liabilities.keys)
        liabilitykeys.sortInPlace()
        capital = accounts["capital"]
        capitalKeys = Array(capital.keys)
        capitalKeys.sortInPlace()
        expenses = accounts["expenses"]
        expensesKeys = Array(expenses.keys)
        expensesKeys.sortInPlace()
        
        let screenWidth = view.frame.width
        
        var initX = tBtn.frame.origin.x
        var initY = tBtn.frame.origin.y
        let btnFont = tBtn.titleLabel?.font
        
        print(assetLabel.frame.width)
        
        // Making buttions of assets
        for key in assetKeys {
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(AssetKeyboardView.test(_:)), forControlEvents: .TouchDown)
            view.addSubview(btn)
            
            btn.frame.origin.x = initX
            btn.frame.origin.y = initY
            
            btn.setTitle(assets[key], forState: .Normal)
            btn.titleLabel?.font = btnFont
            btn.sizeToFit()
            
            if (initX + btn.frame.width > screenWidth) {
                initX = tBtn.frame.origin.x
                initY = initY + btn.frame.height
                btn.frame.origin.x = initX
                btn.frame.origin.y = initY
            }
            
            initX = initX + btn.frame.width + 10
            
        }
        
        // Setting Label of liability
        let liabilityLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: assetLabel.frame.width, height: 20))
        liabilityLabel.backgroundColor = assetLabel.backgroundColor
        liabilityLabel.text = "  부채-"
        liabilityLabel.textColor = UIColor.whiteColor()
        liabilityLabel.font = assetLabel.font
        view.addSubview(liabilityLabel)
        
        // Making buttions of liabilities
        initX = tBtn.frame.origin.x
        initY = liabilityLabel.frame.origin.y + 25
        
        for key in liabilitykeys {
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(AssetKeyboardView.test(_:)), forControlEvents: .TouchDown)
            view.addSubview(btn)
            
            btn.frame.origin.x = initX
            btn.frame.origin.y = initY
            
            btn.setTitle(liabilities[key], forState: .Normal)
            btn.titleLabel?.font = btnFont
            btn.sizeToFit()
            
            if (initX + btn.frame.width > screenWidth) {
                initX = tBtn.frame.origin.x
                initY = initY + btn.frame.height
                btn.frame.origin.x = initX
                btn.frame.origin.y = initY
            }
            
            initX = initX + btn.frame.width + 10
            
        }
        
        // Setting Label of capital
        let capitalLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: assetLabel.frame.width, height: 20))
        capitalLabel.backgroundColor = assetLabel.backgroundColor
        capitalLabel.text = "  자기자본-"
        capitalLabel.textColor = UIColor.whiteColor()
        capitalLabel.font = assetLabel.font
        view.addSubview(capitalLabel)
        
        // Making buttions of capitals
        initX = tBtn.frame.origin.x
        initY = capitalLabel.frame.origin.y + 25
        
        for key in capitalKeys {
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(AssetKeyboardView.test(_:)), forControlEvents: .TouchDown)
            view.addSubview(btn)
            
            btn.frame.origin.x = initX
            btn.frame.origin.y = initY
            
            btn.setTitle(capital[key], forState: .Normal)
            btn.titleLabel?.font = btnFont
            btn.sizeToFit()
            
            if (initX + btn.frame.width > screenWidth) {
                initX = tBtn.frame.origin.x
                initY = initY + btn.frame.height
                btn.frame.origin.x = initX
                btn.frame.origin.y = initY
            }
            
            initX = initX + btn.frame.width + 10
            
        }

        // Setting Label of expenses
        let expensesLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: assetLabel.frame.width, height: 20))
        expensesLabel.backgroundColor = assetLabel.backgroundColor
        expensesLabel.text = "  자기자본-"
        expensesLabel.textColor = UIColor.whiteColor()
        expensesLabel.font = assetLabel.font
        view.addSubview(expensesLabel)
        
        // Making buttions of expenses
        initX = tBtn.frame.origin.x
        initY = expensesLabel.frame.origin.y + 25
        
        for key in expensesKeys {
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(AssetKeyboardView.test(_:)), forControlEvents: .TouchDown)
            view.addSubview(btn)
            
            btn.frame.origin.x = initX
            btn.frame.origin.y = initY
            
            btn.setTitle(expenses[key], forState: .Normal)
            btn.titleLabel?.font = btnFont
            btn.sizeToFit()
            
            if (initX + btn.frame.width > screenWidth) {
                initX = tBtn.frame.origin.x
                initY = initY + btn.frame.height
                btn.frame.origin.x = initX
                btn.frame.origin.y = initY
            }
            
            initX = initX + btn.frame.width + 10
            
        }
        
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    // MARK:- Button actions from .xib file
    @IBAction func test(sender: AnyObject) {
        self.delegate?.leftAccountKeyWasTapped((sender.titleLabel!?.text)!)
    }
    
}
