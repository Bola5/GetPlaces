//
//  PlacesViewController.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController {

    // MARK: - Properties
    private let locationManager = CLLocationManager()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getCurrentLocation()
    }

    // MARK: - setupViews
    private func setupViews() {
        
        view.backgroundColor = .white
    }

}

// MARK: - Get city from current location
extension PlacesViewController: CLLocationManagerDelegate {
    
    // MARK: - getCurrentLocation
    private func getCurrentLocation() {
        
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self?.locationManager.requestAlwaysAuthorization()
                self?.locationManager.startUpdatingLocation()
            }
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print(locValue.latitude)
        print(locValue.longitude)
        
    }
    
}

