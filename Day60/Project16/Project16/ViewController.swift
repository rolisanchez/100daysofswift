//
//  ViewController.swift
//  Project16
//
//  Created by Victor Rolando Sanchez Jara on 3/5/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", wikiLink: "London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wikiLink: "Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", wikiLink: "Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikiLink: "Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiLink: "Washington,_D.C.")
        let taipei = Capital(title: "Taipei", coordinate: CLLocationCoordinate2D(latitude: 25.105497, longitude: 121.597366), info: "Lots of Bubble Tea", wikiLink: "Taipei")
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
        mapView.addAnnotations([london, oslo, paris, rome, washington, taipei])
        
        let changeMapButton = UIBarButtonItem(title: "Change Map Type", style: .plain, target: self, action: #selector(changeMapType))
        
        navigationItem.rightBarButtonItems = [changeMapButton]
    }
    
    // MARK: MapView Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }
        
        // 2
        let identifier = "Capital"
        
        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
            
        }
        
        annotationView?.pinTintColor = .purple
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        let seeMoreAction = UIAlertAction(title: "See more", style: .default) { action in
            
            let vc = DetailViewController()
            vc.capital = capital
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ac.addAction(seeMoreAction)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
        present(ac, animated: true)
    }

    // MARK: Other Methods
    @objc func changeMapType(){
        let ac = UIAlertController(title: "Change Map Type", message: "Choose a Map Type", preferredStyle: .alert)
        let satelliteAction = UIAlertAction(title: "Satellite", style: .default) { action in
            self.mapView.mapType = .satellite
        }
        let hybridAction = UIAlertAction(title: "Hybrid", style: .default) { action in
            self.mapView.mapType = .hybrid
        }
        let standardAction = UIAlertAction(title: "Standard", style: .default) { action in
            self.mapView.mapType = .standard
        }
        ac.addAction(satelliteAction)
        ac.addAction(hybridAction)
        ac.addAction(standardAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(ac, animated: true)
        
    }

}

