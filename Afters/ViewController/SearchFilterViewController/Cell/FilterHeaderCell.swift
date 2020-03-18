//
//  FilterHeaderCell.swift
//  Afters
//
//  Created by Suyog Kolhe on 23/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit


protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: FilterHeaderCell, section: Int)
}

class FilterHeaderCell:  UITableViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedValue: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FilterHeaderCell.tapHeader(_:))))
    }
            
    override func prepareForReuse(){
        self.titleLabel.text = ""
        self.selectedValue.text = ""
    }
            
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
        
    // Trigger toggle section when tapping on the header
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? FilterHeaderCell else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)        
        self.arrowLabel.rotate(collapsed ? 0.0 : CGFloat(M_PI_2))
    }
    
    
}
