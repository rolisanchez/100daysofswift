//
//  Country.swift
//  Day59Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/4/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var size: Int // In squared kilometers
    var population: Int
    var currency: String
    var mainLanguage: String
}
