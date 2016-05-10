//
//  MenuVC.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/25/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation

class MenuVC: UIViewController {
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
    Actions
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------
    About Segues
-----------------------------------------------------------------------------------------------------------------------------------------
*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toHomeSegue") {
            print("toHome")
        } else if (segue.identifier == "toBSSegue") {
            print("toBS")
        }
    }
    
}