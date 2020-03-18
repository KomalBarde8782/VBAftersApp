//
//  ProfileNotificationCell.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class ProfileNotificationCell: UITableViewCell {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
