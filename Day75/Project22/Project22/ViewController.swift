//
//  ViewController.swift
//  Project22
//
//  Created by Victor Rolando Sanchez Jara on 3/20/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: Properties
    @IBOutlet weak var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    @IBOutlet weak var circleImageView: UIImageView!
    
    var alertShown = false
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        addCircle()
    }
    
    // MARK: Location Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//         if status == .authorizedWhenInUse // If we want to use only when in use
        if status == .authorizedAlways  {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !alertShown {
            let ac = UIAlertController(title: "Found a beacon", message: "Hey! Got a beacon in range", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            alertShown = true
        }
        
        let beaconIdentifier = region.identifier
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity, beaconIdentifier: beaconIdentifier)
        } else {
            update(distance: .unknown, beaconIdentifier: beaconIdentifier)
        }
    }
    
    // MARK: Other Methods
    func addCircle(){
        let circleImage = UIImage(named: "Circle")
        circleImageView.image = circleImage
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.circleImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        })

    }
    
    func startScanning() {
        print("startScanning")
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "FirstBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
        let uuid2 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 457, identifier: "Second Beacon")

        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(in: beaconRegion2)
    }
    
    func update(distance: CLProximity, beaconIdentifier: String) {
        print("update")

        UIView.animate(withDuration: 1) {
            switch distance {
                case .unknown:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWN\n\(beaconIdentifier)"
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self.circleImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    })

                case .far:
                    self.view.backgroundColor = UIColor.blue
                    self.distanceReading.text = "FAR\n\(beaconIdentifier)"
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self.circleImageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                    })
                case .near:
                    self.view.backgroundColor = UIColor.orange
                    self.distanceReading.text = "NEAR\n\(beaconIdentifier)"
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self.circleImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    })
                case .immediate:
                    self.view.backgroundColor = UIColor.red
                    self.distanceReading.text = "RIGHT HERE\n\(beaconIdentifier)"
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self.circleImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
                default:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWN\n\(beaconIdentifier)"
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self.circleImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    })
                // Alternative
//                @unknown default:
//                    self.view.backgroundColor = .black
//                    self.distanceReading.text = "WHOA!"
            
            }
        }
    }
}

