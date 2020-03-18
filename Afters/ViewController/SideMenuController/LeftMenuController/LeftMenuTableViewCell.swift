//
//  LeftMenuTableViewCell.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 16/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {
    @IBOutlet var title : UILabel?
    @IBOutlet var icon : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray
        self.selectedBackgroundView = view
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
}
