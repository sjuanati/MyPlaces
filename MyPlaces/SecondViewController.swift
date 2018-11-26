//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit
import MapKit

// Map controller
class SecondViewController: UIViewController, MKMapViewDelegate, ManagerPlacesObserver {

    func onPlacesChange() {
        RemoveMarkers()
        AddMarkers()
    }
    
    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    let m_location:ManagerLocation = ManagerLocation.shared()
    
    @IBOutlet weak var m_map: MKMapView!

    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        self.m_map?.delegate = self
        
        // Add self observer
        let manager = ManagerPlaces.shared()
        manager.addObserver(object:self)
        
        // Load markers the 1st time
        AddMarkers()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func RemoveMarkers() {
    // Remove all markers
       
        let list = self.m_map.annotations.filter { !($0 is MKUserLocation) }
        self.m_map.removeAnnotations(list)
    }

    
    func AddMarkers() {
    // Add all markers from ManagerPlaces
        
        let provider:ManagerPlaces = ManagerPlaces.shared()
        
        for i in 0..<provider.GetCount() {
            let p = provider.GetItemAt(position: i)
            let title:String = p.name
            let id:String = p.id
            let lat:Double = p.location.latitude
            let lon:Double = p.location.longitude
            let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat,longitude: lon),
                                                                     title: title,
                                                                     place_id: id)
            self.m_map.addAnnotation(annotation)
        }
        
    // Add current user location
        
        //TODO PLA4 : get user location and measure distances to stored places
        /*
        if provider.GetCount() > 0 {
            print("user latitude test = \(m_location.userLocation!.coordinate.latitude)")
            print("user longitude test = \(m_location.userLocation!.coordinate.longitude)")
            let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate:CLLocationCoordinate2D(latitude: m_location.userLocation!.coordinate.latitude,
                                   longitude: m_location.userLocation!.coordinate.longitude),
                                    title: "Your location",
                                    place_id: "")
       
            self.m_map.addAnnotation(annotation)
            // TODO: Canviar el pin pq el mostri com a posició actual
        }
    */
        
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Provides the map with a view from a MKMyPointAnnotation

        if let annotation = annotation as? MKMyPointAnnotation {
            
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation,
                                              reuseIdentifier: identifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                pinView.setSelected(true,animated: true)
            }

            return pinView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Show Place details (from DetailController) when clicking a marker
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        if annotation.title != "Your location" {
            let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
            let place: Place = m_provider.GetItemById(id: annotation.place_id)
            dc.place = place
            present(dc, animated: true, completion: nil)
        }
    }
    
}

