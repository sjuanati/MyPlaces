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

class ManagerPlaces {
    
    var places:[Place] = []
    // Llistat d'observadors
    public var m_observers = Array<ManagerPlacesObserver>()
    
    
    // Singleton: única instància per tota l'app
    private static var sharedManagerPlaces: ManagerPlaces = {
        var singletonManager:ManagerPlaces
        singletonManager = ManagerPlaces()
        return singletonManager
    } ()

    class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
    }
    
    // Afegir un Place
    func append(_ value:Place) {
        places.append(value)
    }

    // Actualitzar un Place per ID
    func update(id:String, name:String, description:String, image_in:Data?, location_in:CLLocationCoordinate2D!) {
        places.first(where: {$0.id == id})?.name = name
        places.first(where: {$0.id == id})?.description = description
        places.first(where: {$0.id == id})?.image = image_in // Out of scope PLA2
        places.first(where: {$0.id == id})?.location = location_in // Out of scope PLA2
    }
    
    // Conèixer el número total de Places
    func GetCount()->Int {
        return places.count
    }
    
    // Obtenir un Place per posició **COMPTE! peta si s'accedeix i no queden elements a la llista
    func GetItemAt(position:Int)->Place {
        return places[position]
    }
    
    // Obtenir un Place per ID
    func GetItemById(id:String)->Place {
        return places.filter({$0.id.elementsEqual(id)})[0]
    }
    
    // Esborrar un element per id
    func remove(id:String) {
        places = places.filter({$0.id != id})
    }

    // Afegir un element a la llista m_observers
    public func addObserver(object:ManagerPlacesObserver) {
        m_observers.append(object)
    }
    
    // Executar a cada observer de la llista el mètode onPlacesChange.
    public func UpdateObservers() {
        let numObservers = m_observers.count
        if numObservers > 0 {
            for i in 0..<numObservers {
                m_observers[i].onPlacesChange()
            }
        }
    }
    
}



