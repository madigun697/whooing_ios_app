//
//  entryTableViewCell.swift
//  whooing_ios_app
//
//  Created by Kail Madigun on 4/28/16.
//  Copyright © 2016 Kail Madigun. All rights reserved.
//

import UIKit

class entryTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var cellDateLabel: UILabel!
    @IBOutlet var cellAccountLabel: UILabel!
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellMoneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
