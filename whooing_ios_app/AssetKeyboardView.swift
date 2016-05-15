//
//  AssetKeyboardView.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 5/15/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class AssetKeyboardView: UIView {
    
    @IBOutlet var tBtn: UIButton!
    @IBOutlet var assetLabel: UILabel!
//    @IBOutlet var liabilityLabel: UILabel!
    @IBOutlet var equityLabel: UILabel!
    
    // Application's defaults variables
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var accounts:[String:[String:String]]!
    var assets:[String:String]!
    var assetKeys:[String]!
    var liabilitykeys:[String]!
    var liabilities:[String:String]!
    
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
        
        let screenWidth = view.frame.width
        
//        var initX:CGFloat = 0
        var initX = tBtn.frame.origin.x
        var initY = tBtn.frame.origin.y
        let btnFont = tBtn.titleLabel?.font
        
        print(assetLabel.frame.width)
        
        for key in assetKeys {
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
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
        
        let liabilityLabel = UILabel(frame: CGRect(x: 0, y: initY + 28, width: view.frame.width, height: 20))
        liabilityLabel.backgroundColor = assetLabel.backgroundColor
        liabilityLabel.text = "  부채-"
        liabilityLabel.textColor = UIColor.whiteColor()
        liabilityLabel.font = assetLabel.font
        view.addSubview(liabilityLabel)
        
//        tBtn.setTitle("test", forState: .Normal)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    // MARK:- Button actions from .xib file
    @IBAction func test(sender: AnyObject) {
        self.delegate?.keyWasTapped((sender.titleLabel!?.text)!)
    }
    
}
