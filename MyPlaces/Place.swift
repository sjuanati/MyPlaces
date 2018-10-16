//
//  Place.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import Foundation
import MapKit

class Place {

    enum PlacesTypes: Int, Codable {
        case GenericPlace
        case TouristicPlace
    }
    
    var id: String = ""
    var type: PlacesTypes = .GenericPlace
    var name: String = ""
    var description: String = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil
    
    init() {
        self.id = UUID().uuidString
    }

    init(name:String, description:String, image_in:Data?) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
    }

    init(type:PlacesTypes, name:String, description:String, image_in:Data?, location_in:CLLocationCoordinate2D!) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.description = description
        self.image = image_in
        self.location = location_in
    }

}
