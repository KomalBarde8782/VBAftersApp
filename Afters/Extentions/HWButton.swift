//
//  HWButton.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 09/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

@IBDesignable class NBPButton: UIButton {
    
    @IBInspectable var gredientTopColor: UIColor!
    @IBInspectable var gredientBottomColor: UIColor!
    @IBInspectable var borderColor: UIColor!    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:(self.frame.size.width/2),
        //            bottom: 0, right: 0)
        super.draw(rect)
        self.addGradient(rect)
    }
    
    override func imageRect(forContentRect contentRect:CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = self.frame.maxX - 70
        return imageFrame
    }
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    public func addGradient(_ rect: CGRect){
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.cgColor
        //        let gradient:CAGradientLayer = CAGradientLayer()
        //        gradient.frame.size = rect.size
        //        gradient.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor] //Or any colors
        //        self.layer.insertSublayer(gradient, at:0)
        self.layer.masksToBounds = true;
    }
}

@IBDesignable class NBPTextView: UITextView {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.addBorder(rect)        
    }
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    public func addBorder(_ rect: CGRect) {
        //        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.cgColor
    }
    
}

@IBDesignable class NBPTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor!
    @IBInspectable var paddingLeft: CGFloat = 5
    @IBInspectable var paddingRight: CGFloat = 5
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    internal override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    internal override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    internal override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.addBorder(rect)
        
    }
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    internal func addBorder(_ rect: CGRect){
        //        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 2
        let placeholderAttrs = [ convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: convertToOptionalNSAttributedStringKeyDictionary(placeholderAttrs))
        self.attributedPlaceholder = placeholder
    }
    
}

@IBDesignable class NBTLabel: UILabel {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
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
        //        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.cgColor
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
