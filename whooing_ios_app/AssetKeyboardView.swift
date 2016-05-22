//
//  AssetKeyboardView.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 5/15/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

protocol L_KeyboardDelegate: class {
    func leftAccountKeyWasTapped(character: String)
}

class AssetKeyboardView: UIView {
    
    @IBOutlet var tBtn: UIButton!
    @IBOutlet var tLabel: UILabel!
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    var screenWidth:CGFloat = 0
    
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
    weak var delegate: L_KeyboardDelegate?
    
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
        
        screenWidth = defaults.objectForKey("screenWidth") as! CGFloat
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260))
        scrollView.canCancelContentTouches = true
        scrollView.delaysContentTouches = false
        
        let xibFileName = "AssetKeyboardView" // xib extention not included
        let view = NSBundle.mainBundle().loadNibNamed(xibFileName, owner: self, options: nil)[0] as! UIView
        
        tBtn.hidden = true
        tLabel.hidden = true
        
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
        
        var initX = tBtn.frame.origin.x
        var initY = tBtn.frame.origin.y
        let btnFont = tBtn.titleLabel?.font
        let labelBackgroundColor = tLabel.backgroundColor
        let labelFont = tLabel.font
        
        // Setting Label of asset
        let assetLabel = UILabel(frame: CGRect(x: tLabel.frame.origin.x, y: tLabel.frame.origin.y, width: screenWidth, height: 20))
        assetLabel.backgroundColor = labelBackgroundColor
        assetLabel.text = tLabel.text
        assetLabel.textColor = UIColor.whiteColor()
        assetLabel.font = labelFont
        view.addSubview(assetLabel)
        
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
        let liabilityLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: screenWidth, height: 20))
        liabilityLabel.backgroundColor = labelBackgroundColor
        liabilityLabel.text = "  부채-"
        liabilityLabel.textColor = UIColor.whiteColor()
        liabilityLabel.font = labelFont
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
        let capitalLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: screenWidth, height: 20))
        capitalLabel.backgroundColor = labelBackgroundColor
        capitalLabel.text = "  자기자본-"
        capitalLabel.textColor = UIColor.whiteColor()
        capitalLabel.font = labelFont
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
        let expensesLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: screenWidth, height: 20))
        expensesLabel.backgroundColor = labelBackgroundColor
        expensesLabel.text = "  지출-"
        expensesLabel.textColor = UIColor.whiteColor()
        expensesLabel.font = labelFont
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
        
        scrollView.scrollEnabled = true
        scrollView.contentSize.height = initY + 35
        scrollView.backgroundColor = UIColor.whiteColor()
        
        scrollView.addSubview(view)
        self.addSubview(scrollView)
        
        view.frame = self.bounds
    }
    
    // MARK:- Button actions from .xib file
    @IBAction func test(sender: AnyObject) {
        self.delegate?.leftAccountKeyWasTapped((sender.titleLabel!?.text)!)
    }
    
}
