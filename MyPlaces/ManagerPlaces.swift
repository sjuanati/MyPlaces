//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import Foundation
import CoreLocation

protocol ManagerPlacesObserver {
    func onPlacesChange()
}

class ManagerPlaces : Codable {
    
    var places:[Place] = []
    
    // Observers list
    public var m_observers = Array<ManagerPlacesObserver>()
    
    // Serialization
    enum CodingKeys: String, CodingKey {
        case places
    }
    enum PlacesTypeKey: CodingKey {
        case type
    }
    
    // Singleton: unique instance for the whole app
    private static var sharedManagerPlaces: ManagerPlaces = {
        var singletonManager:ManagerPlaces?
        singletonManager = load() //JSON
        if (singletonManager == nil) {
            singletonManager = ManagerPlaces()
        }
        return singletonManager!
    } ()

    
    class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
    }
    
    
    // Add a Place
    func append(_ value:Place) {
        places.append(value)
    }

    
    // Update a Place by ID
    func update(id:String, name:String, description:String, image_in:Data?, location_in:CLLocationCoordinate2D!) {
        places.first(where: {$0.id == id})?.name = name
        places.first(where: {$0.id == id})?.description = description
        places.first(where: {$0.id == id})?.image = image_in // Out of scope PLA2
        places.first(where: {$0.id == id})?.location = location_in // Out of scope PLA2
    }
    
    
    // Get total number of Places
    func GetCount() -> Int {
        return places.count
    }
    
    
    // Get a Place by position
    // TODO Fails if called and there are no Places
    func GetItemAt(position:Int) -> Place {
        return places[position]
    }
    
    
    // Get a Place by ID
    func GetItemById(id:String) -> Place {
        return places.filter({$0.id.elementsEqual(id)})[0]
    }
    
    
    // Remove a place by ID
    func remove(id:String) {
        places = places.filter({$0.id != id})
        store()
    }

    
    // Check if a place name already exists (case sensitive)
    func checkRepeated(nameRepe:String) -> Bool {
        if places.contains(where: {$0.name.compare(nameRepe, options: .caseInsensitive) == .orderedSame}) {
            return true
        } else {
            return false
        }
    }
    
    
    // Add an object into the observers' list
    public func addObserver(object:ManagerPlacesObserver) {
        m_observers.append(object)
    }
    
    
    // Call onPlacesChange() for every object within the observers' list
    public func UpdateObservers() {
        let numObservers = m_observers.count
        if numObservers > 0 {
            for i in 0..<numObservers {
                m_observers[i].onPlacesChange()
            }
        }
    }

    
    // Get path from place image by ID
    func GetPathImage(p:Place) -> String {
        let r = FileSystem.GetPathImage(id: p.id)
        return r
    }
 
    
    // ************* ManagerPlaces Serialization *************
    

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(places, forKey: .places)
    }

    
    func store() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            for place in places {
                if (place.image != nil) {
                    FileSystem.WriteData(id:place.id,image:place.image!)  // write image
                    place.image = nil;
                }
            }
            FileSystem.Write(data: String(data: data, encoding: .utf8)!)  // write text
        }
        catch
        {
        }

    }
    
    
    //  ************* ManagerPlaces Deserialization *************
    
    func decode(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = [Place]()
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.places)
        var tmp_array = objectsArrayForType
        
        while(!objectsArrayForType.isAtEnd) {
            
            let object = try objectsArrayForType.nestedContainer(keyedBy: PlacesTypeKey.self)
            let type = try object.decode(Place.PlacesTypes.self, forKey: PlacesTypeKey.type)
            
            switch type {
                case Place.PlacesTypes.TouristicPlace:
                    self.append(try tmp_array.decode(PlaceTourist.self))
                default:
                    self.append(try tmp_array.decode(Place.self)) }
        }
    }

    
    // ************* Different Array types Deserialization *************
    
    static func load() -> ManagerPlaces? {
        
        var resul:ManagerPlaces? = nil
        let data_str = FileSystem.Read()
        
        if (data_str != "") {
            do {
                let decoder = JSONDecoder()
                let data:Data = Data(data_str.utf8)
                resul = try decoder.decode(ManagerPlaces.self,from: data)
            }
            catch
            {
                resul = nil
            }
        }
        return resul
    }
    
    
}



