//
//  FilterSelectAgeAndMusicCell.swift
//  Afters
//
//  Created by Suyog Kolhe on 23/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class FilterSelectAgeAndMusicCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse(){
        self.textField.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
