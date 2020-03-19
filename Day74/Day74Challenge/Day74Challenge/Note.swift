//
//  Note.swift
//  Day74Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/19/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import Foundation

struct Note: Codable {
    var id: UUID = UUID()
    var content: String
}
