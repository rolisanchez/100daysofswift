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
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
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
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    // MARK: Other Methods
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
                case .unknown:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWN"
                
                case .far:
                    self.view.backgroundColor = UIColor.blue
                    self.distanceReading.text = "FAR"
                
                case .near:
                    self.view.backgroundColor = UIColor.orange
                    self.distanceReading.text = "NEAR"
                
                case .immediate:
                    self.view.backgroundColor = UIColor.red
                    self.distanceReading.text = "RIGHT HERE"
                default:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWN"
                // Alternative
//                @unknown default:
//                    self.view.backgroundColor = .black
//                    self.distanceReading.text = "WHOA!"
            
            }
        }
    }
}

