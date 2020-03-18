//
//  PartyAddressCell.swift
//  Afters
//
//  Created by C332268 on 20/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class PartyAddressCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
}
