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
class SecondViewController: UIViewController, MKMapViewDelegate {

    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    
    @IBOutlet weak var m_map: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SJS: testing
        
        self.m_map?.delegate = self
        AddMarkers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func RemoveMarkers() {
    // Remove all markers or indicators
       
        let list = self.m_map.annotations.filter { !($0 is MKUserLocation) }
        self.m_map.removeAnnotations(list)
    }

    
    func AddMarkers() {
    // Add markers or indicators from ManagerPlaces
        
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
        print("mapview1")
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Show DetailController's Place when clicking a marker
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        let place: Place = m_provider.GetItemById(id: annotation.place_id)
        dc.place = place
        present(dc, animated: true, completion: nil)
        
    }
    
    
}

