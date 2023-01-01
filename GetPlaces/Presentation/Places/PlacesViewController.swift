//
//  PlacesViewController.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController {

    // MARK: - ViewModel
    private let viewModel: PlacesViewModelProtocol
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()

    // MARK: - Init
    // With viewModel
    init(viewModel: PlacesViewModelProtocol = PlacesViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.fetchPlaces(lat: locValue.latitude.description, lon: locValue.longitude.description)
    }
    
}

// MARK: - Fetch Places
extension PlacesViewController {
    
    private func fetchPlaces(lat: String, lon: String) {
        LoadingManager.sharedInstance.showIndicator()
        viewModel.fetchPlaces(lat: lat, lon: lon, completion: { [weak self] result in
            LoadingManager.sharedInstance.hideIndicator()
            switch result {
            case .success:
                self?.handleFetchSuccess()
            case .failure(let error):
                self?.handleFailure(error: error.getStringError() ?? "")
            }
        })
    }
    
    private func handleFetchSuccess() {
        DispatchQueue.main.async { [weak self] in
            
        }
    }
    
    private func handleFailure(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorAlert(message: error)
        }
    }
    
}
