//
//  Capital.swift
//  Project16
//
//  Created by Victor Rolando Sanchez Jara on 3/5/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String = ""
    var wikiLink: String = ""
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wikiLink: String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikiLink = wikiLink
    }
    
}
