//
//  HWRoundedCornerView.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 18/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

@IBDesignable class HWRoundedCornerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.addBorder(rect)
        
    }    
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    func addBorder(_ rect: CGRect) {        
        self.layer.cornerRadius = 2;
    }

    
}
