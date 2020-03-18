//
//  ProfileDetailCell.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse(){
        self.titleLabel.text = ""
        self.valueLabel.text = ""
        self.valueLabel.inputView = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
