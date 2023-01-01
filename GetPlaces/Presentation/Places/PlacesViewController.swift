//
//  PlacesViewController.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import UIKit
import CoreLocation
import MapKit

class PlacesViewController: UIViewController {

    // MARK: - UI
    private let mapView = MKMapView()
    
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
        title = Strings.TITLE
        
        // mapView
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
    }

}

// MARK: - Current location and mapView
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
        
//        let location = CLLocationCoordinate2D(latitude: Double(locValue.latitude),
//                                              longitude: Double(locValue.latitude))
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapView.setRegion(region, animated: true)
        
        fetchPlaces(lat: "30.0444", lon: "31.2357")
    }
    
    // MARK: - setupPlaceOnMap
    private func setupPlaceOnMap(place: PlacesLayoutViewModel.PlacesInfoLayoutViewModel) {
        
        let location = CLLocationCoordinate2D(latitude: Double(place.lat) ?? 0,
                                              longitude: Double(place.lat) ?? 0)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = place.name
        annotation.subtitle = place.streetName
        mapView.addAnnotation(annotation)
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
            guard let places = self?.viewModel.places else { return }
            for place in places {
                self?.setupPlaceOnMap(place: place)
            }
        }
    }
    
    private func handleFailure(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorAlert(message: error)
        }
    }
    
}
