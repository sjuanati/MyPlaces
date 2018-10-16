//
//  PlaceTourist.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceTourist: Place {

    var discount_tourist: String = ""
    
    override init() {
        super.init()
        type = .TouristicPlace
    }

    init(name:String, description:String, discount_tourist:String, image_in:Data?, location_in:CLLocationCoordinate2D!) {
        super.init(type:.TouristicPlace, name:name, description:description, image_in:image_in, location_in: location_in)
        self.discount_tourist = discount_tourist
    }
    
}

