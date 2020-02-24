//
//  Image.swift
//  Day50
//
//  Created by Victor Rolando Sanchez Jara on 2/24/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import Foundation
//import UIKit

class Image: NSObject, Codable {
    var fileName: String
    var caption: String
    
    init(fileName: String, caption: String) {
        self.fileName = fileName
        self.caption = caption
    }
}
