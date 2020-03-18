//
//  LocationSelectionDelegate.swift
//  Afters
//
//  Created by Komal Barde on 05/03/2020.
//  Copyright © 2020 Suyog Kolhe. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationSelectionForPartyDelegate {
    func selected(_ location:CLLocation , address: String)
}
