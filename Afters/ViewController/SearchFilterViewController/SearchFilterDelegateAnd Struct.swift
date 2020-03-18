//
//  SearchFilterDelegateAnd Struct.swift
//  Afters
//
//  Created by Komal Barde on 05/03/2020.
//  Copyright © 2020 Suyog Kolhe. All rights reserved.
//

import Foundation

struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    var selectedValue : String = ""
    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

protocol SearchFilterDelegate {
    func refreshSearchFilter()
}
