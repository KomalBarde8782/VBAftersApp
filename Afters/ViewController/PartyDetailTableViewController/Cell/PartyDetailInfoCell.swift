//
//  PartyDetailInfoCell.swift
//  Afters
//
//  Created by C332268 on 26/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class PartyDetailInfoCell: UITableViewCell {

    
    @IBOutlet weak var partyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var partyDescription: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
