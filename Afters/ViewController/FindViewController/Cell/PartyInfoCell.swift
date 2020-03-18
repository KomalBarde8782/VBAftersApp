//
//  PartyInfoCell.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class PartyInfoCell: UITableViewCell {

    @IBOutlet weak var partyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var partyDescription: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var attending: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favouritButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse(){
        self.partyImageView.image = nil
        self.titleLabel.text = ""
        self.partyDescription.text = ""
        self.age.text = ""
        self.attending.text = ""
        
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
