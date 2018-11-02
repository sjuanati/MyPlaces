//
//  MKMyPointAnnotation.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 31/10/2018.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class MKMyPointAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var place_id:String = ""
    
    init(coordinate: CLLocationCoordinate2D, title:String, place_id:String) {
        self.coordinate = coordinate
        self.title = title
        self.place_id = place_id
    }
    
}


