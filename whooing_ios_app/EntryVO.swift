//
//  EntryVO.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/24/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import Foundation

class EntryVO : NSObject, NSCoding {
    var entry_date:String?
    var entry_title:String?
    var money:Int?
    var l_account:String?
    var l_account_id:String?
    var r_account:String?
    var r_account_id:String?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.entry_date = aDecoder.decodeObjectForKey("entry_date") as? String
        self.entry_title = aDecoder.decodeObjectForKey("entry_title") as? String
        self.money = aDecoder.decodeObjectForKey("money") as? Int
        self.l_account = aDecoder.decodeObjectForKey("l_account") as? String
        self.l_account_id = aDecoder.decodeObjectForKey("l_account_id") as? String
        self.r_account = aDecoder.decodeObjectForKey("r_account") as? String
        self.r_account_id = aDecoder.decodeObjectForKey("r_account_id") as? String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.entry_date, forKey: "entry_date")
        aCoder.encodeObject(self.entry_title, forKey: "entry_title")
        aCoder.encodeObject(self.money, forKey: "money")
        aCoder.encodeObject(self.l_account, forKey: "l_account")
        aCoder.encodeObject(self.l_account_id, forKey: "l_account_id")
        aCoder.encodeObject(self.r_account, forKey: "r_account")
        aCoder.encodeObject(self.r_account_id, forKey: "r_account_id")
    }
}