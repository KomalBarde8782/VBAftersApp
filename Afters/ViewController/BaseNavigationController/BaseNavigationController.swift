//
//  BaseNavigationController.swift
//  Afters
//
//  Created by C332268 on 10/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView.init(image: UIImage(named:"navBar_White_Icon"))
        self.navigationItem.titleView = imageView;
    }
}
