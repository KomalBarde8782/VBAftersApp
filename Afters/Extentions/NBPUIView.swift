//
//  NBPUIView.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit



@IBDesignable class NBPUIView: UIView {
    
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
    
    func addBorder(_ rect: CGRect){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = true;
    }

}


@IBDesignable class NBPRoundedImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.addBorder(rect)
        
    }
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    public func addBorder(_ rect: CGRect){
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = true;
    }
    
}

extension UIButton{
    
    public func setHalfRound() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true;
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = UIColor.white.cgColor
    }

}

extension UIImageView {
    
    public func imageFromUrl(_ urlString: String , isRounded : Bool)  {
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { (response, data, error) in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                    if isRounded == true{
                        self.setRounded()
                    }
                }
            })
        }
    }
    
    public func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true;
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = UIColor.white.cgColor
    }

    public func imageFromUrl(_ urlString: String , image : UIImage?)  {
        var imageL = image
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { (response, data, error) in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                    imageL = self.image
                }
            })
        }
    }
}

extension UIView {
    
    public func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
}

extension String{
    
    func toBool()-> Bool{
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}



