//
//  HostDetailCell.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class HostDetailCell: UITableViewCell {

    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        self.descriptionTextView.text = ""
        self.titleLabel.text = ""
        self.descriptionTextField.text = ""
        self.descriptionTextField.inputView = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
