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
    private let searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)

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
        
        // searchBar
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        searchBar.searchBarStyle = .default
        searchBar.placeholder = Strings.SEARCH_PLACEHOLDER
        searchBar.sizeToFit()
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        // mapView
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        fetchPlaces(lat: locValue.latitude.description, lon: locValue.longitude.description)
    }
    
    // MARK: - setupPlaceOnMap
    private func setupPlaceOnMap(places: [PlacesLayoutViewModel.PlacesInfoLayoutViewModel]) {
        
        var annotations = [MKAnnotation]()

        for place in places {
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.streetName
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(place.lat) ?? 0, longitude: Double(place.lon) ?? 0)
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)

        if let lastAnnotation = annotations.last {
            let region = MKCoordinateRegion(center: lastAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.setRegion(region, animated: true)
        }
        
    }
    
}

// MARK: - Search for a city
extension PlacesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        fetchPositionByCity(city: city)
        self.searchBar.text = ""
        self.searchBar.endEditing(true)
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
            self?.setupPlaceOnMap(places: places)
        }
    }
    
    private func handleFailure(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorAlert(message: error)
        }
    }
    
}

// MARK: - Fetch Position
extension PlacesViewController {
    
    private func fetchPositionByCity(city: String) {
        LoadingManager.sharedInstance.showIndicator()
        viewModel.fetchPosition(city: city, completion: { [weak self] result in
            LoadingManager.sharedInstance.hideIndicator()
            switch result {
            case .success:
                self?.handleFetchSuccessPositionByCity()
            case .failure(let error):
                self?.handleFailure(error: error.getStringError() ?? "")
            }
        })
    }
    
    private func handleFetchSuccessPositionByCity() {
        guard let position = self.viewModel.position else { return }
        self.fetchPlaces(lat: String(position.lat), lon: String(position.lon))
    }
    
    private func handleFailurePositionByCity(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorAlert(message: error)
        }
    }
    
}
