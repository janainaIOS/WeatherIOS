//
//  WeatherListVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit
import CoreLocation

class WeatherListVC: UIViewController, UITextFieldDelegate {
    
    private let viewModel = WeatherViewModel()
    private var activityIndicator: ActivityIndicator!
    let locationManager = CLLocationManager()
    private var currentLocation: (Double,Double) = (0,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Initial settings
    private func configure() {
        activityIndicator = ActivityIndicator(view: self.view)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let f: [DBForecast] = CoredataManager.shared.fetchAllForecasts() ?? []
        print("fetchAllForecasts \(f.count)")
    }
    
    /// API call for weather details of current location
    /// API call for weather details using location coordinates
    private func getWeatherOfCurrentLocation() {
        // API call for weather details using location coordinates
        self.activityIndicator.startAnimaton()
        self.viewModel.getWeatherDetail(lat: String(currentLocation.0), lng: String(currentLocation.1)) { model in
            self.activityIndicator.stopAnimaton()
            
            /// check weather details available and send to SearchLocationtVCDelegate
            if let weatherDetails = model, weatherDetails.cityName != "" {
                
            } else {
                Toast.show(AlertMessages.weatherEmptyAlert)
            }
        }
    }
    
    // MARK: - Button Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        /// search location and fetch weather data
        self.presentViewController(SearchLocationtVC.self, storyboard: Storyboards.main) { vc in
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
        }
    }
    
}

// MARK: - LocationManager Delegates
extension WeatherListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // save app's currrent location
        currentLocation = (locations.last?.coordinate.latitude ?? 0, locations.last?.coordinate.longitude ?? 0)
        print("locations  \(currentLocation)")
        print("stopUpdatingLocation")
        locationManager.stopUpdatingLocation()
        
        ///get weather details
        getWeatherOfCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
        checkLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization")
        checkLocation()
    }
    
    /// Check app's Location access permission
    func checkLocation()  {
        print("checkLocation")
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            // Request when-in-use authorization initially
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            // Disable location features
            self.appPermissionAlert(type: "location")
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            self.enableMyWhenInUseFeatures()
            break
        default:
            print("default")
            break
        }
        
    }
    
    /// Start fetching current location
    func enableMyWhenInUseFeatures() {
        print("enableMyWhenInUseFeatures")
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Custom Delegates

//SearchLocationtVC Delegates
extension WeatherListVC: SearchLocationtVCDelegate {
    ///Show weather deatil on WeatherDetailVC
    func weatherDetailFetched(weather: Weather) {
        DispatchQueue.main.async {
            self.presentViewController(WeatherDetailVC.self, storyboard: Storyboards.main) { vc in
                // Add forcast details form Weather model
                vc.forecast?.city?.id = weather.id
                vc.forecast?.city?.name = weather.cityName
                vc.forecast?.city?.coord = weather.cordinate
                vc.forecast?.city?.sunrise = weather.sys?.sunrise ?? 0
                vc.forecast?.city?.sunset = weather.sys?.sunset ?? 0
            }
        }
    }
}

