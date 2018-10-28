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

    enum CodingKeysTourist: String, CodingKey {
        case discount_tourist
    }
    
    var discount_tourist: String = ""
    
    override init() {
        super.init()
        type = .TouristicPlace
    }

    init(name:String, description:String, discount_tourist:String, image_in:Data?, location_in:CLLocationCoordinate2D!) {
        super.init(type:.TouristicPlace, name:name, description:description, image_in:image_in, location_in: location_in)
        self.discount_tourist = discount_tourist
    }

    // PlaceTourist Serialization
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysTourist.self)
        try container.encode(discount_tourist, forKey: .discount_tourist)
        try super.encode(to: encoder)
    }
    
    // PlaceTourist Deserialization
    
    override func decode(from decoder: Decoder) throws {
        try super.decode(from:decoder)
        let container = try decoder.container(keyedBy: CodingKeysTourist.self)
        discount_tourist = try container.decode(String.self, forKey: .discount_tourist)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decode(from:decoder)
    }
    
}

