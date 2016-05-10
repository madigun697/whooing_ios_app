//
//  KeyboardViewController.swift
//  AssetKeyboard
//
//  Created by Kail Madigun on 5/10/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var AssetKeyView: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
    
    func btnPressed(sender: AnyObject) {
        var btn = sender as! UIButton
        var stringToInsert = ""
        let proxy = self.textDocumentProxy as UIKeyInput
        
        switch (btn.tag) {
        case 5:
            stringToInsert = "adsf"
        default:
            stringToInsert = "qwer"
        }
        
        proxy.insertText(stringToInsert)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var xibViews = NSBundle.mainBundle().loadNibNamed("AssetKeyboard", owner: self, options: nil)
        self.AssetKeyView = xibViews[0] as! UIView
        self.view.addSubview(AssetKeyView)
        
        for v in self.AssetKeyView.subviews as! [UIButton] {
            v.addTarget(self, action: Selector("btnPressd:"), forControlEvents: .TouchUpInside)
        }
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
    
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
