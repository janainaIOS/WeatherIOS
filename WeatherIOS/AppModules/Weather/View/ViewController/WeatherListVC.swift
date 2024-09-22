//
//  WeatherListVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit
import CoreLocation

class WeatherListVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    private let viewModel = WeatherViewModel()
    private var activityIndicator: ActivityIndicator!
    let locationManager = CLLocationManager()
    private var currentLocFetched: Bool = false
    private var forecastArray: [Forecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Initial settings
    private func configure() {
        activityIndicator = ActivityIndicator(view: self.view)
        //Unit setting
        if let getAppUnit = UserDefaults.standard.appUnit, getAppUnit != "" {
            appUnit = Unit(rawValue: getAppUnit) ?? .metric
        }
        //Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //Fetch list
        getAllDBForecasts(update: true)
    }
    
    /// API call for weather forecast details of current location
    /// API call for weather forecast details using location coordinates
    private func getWeatherForecastOfCurrentLocation(cityName: String) {
        
        // API call for weather details using location coordinates
        self.activityIndicator.startAnimaton()
        self.viewModel.getforecastDetails(itemCount: 40, cityName: cityName) { model in
            self.activityIndicator.stopAnimaton()
            
            /// check weather details available and update into userdefaults
            if let forecastDetails = model, forecastDetails.city.name != "" {
                //save current location forecast
                UserDefaults.standard.currentLocation = forecastDetails
                
                //Show current location in the list
                self.getAllDBForecasts(update: false)
            }
        }
    }
    
    
    private func getLatestWeatherDataAndUpdate(forecasts: [DBForecast], completion:@escaping () -> Void) {
        // API call for weather details using location id
        self.activityIndicator.startAnimaton()
        
        var completionCount = 0
        let totalCount = forecasts.count
        
        for location in forecasts {
            self.viewModel.getforecastDetails(itemCount: 40, cityId: Int(location.id)) { model in
                
                /// check weather details available and update into database
                if let forecastDetails = model, forecastDetails.city.name != "" {
                    CoredataManager.shared.insertOrUpdateForecast(forecast: forecastDetails) { tatus in
                        completionCount += 1
                        
                        if completionCount == totalCount {
                            self.activityIndicator.stopAnimaton()
                            completion()
                        }
                        
                    }
                } else {
                    completionCount += 1
                    
                    if completionCount == totalCount {
                        self.activityIndicator.stopAnimaton()
                        completion()
                    }
                }
            }
        }
        
    }
    
    /// Fetch  all forecast details from coredata
    /// if "update" is true, database will get updated from the values of forecast api
    private func getAllDBForecasts(update: Bool) {
        CoredataManager.shared.fetchAllForecasts { forecasts in
            let forecastDBArray = forecasts ?? []
            
            if update && forecastDBArray.count != 0 {
                self.getLatestWeatherDataAndUpdate(forecasts: forecastDBArray) {
                    
                    self.showForecastsList(forecasts: forecastDBArray)
                }
            } else {
                self.showForecastsList(forecasts: forecastDBArray)
            }
        }
    }
    
    private func showForecastsList(forecasts: [DBForecast]) {
        self.forecastArray.removeAll()
        for dbForcast in forecasts {
            if let weather = self.viewModel.DBForecastToForecast(dbforecast: dbForcast) {
                self.forecastArray.append(weather)
            }
        }
        /// Add current location to the top of the list
      
        if let currentLocForecast = UserDefaults.standard.currentLocation, currentLocFetched {
            ///Update "isHome" to show current location view
            guard var currentLoc = UserDefaults.standard.currentLocation else { return }
            currentLoc.isHome = true
            self.forecastArray.insert(currentLoc, at: 0)
        }
        /// Removes duplicate elements from an array based on a unique key.
        /// Remove current location if its already added in database
        forecastArray = forecastArray.removingDuplicates(byKey: \.city.name)
        listTableView.reloadData()
        
        if forecastArray.count == 0 {
            listTableView.setEmptyMessage(AlertMessages.weatherEmptyAlert)
        } else {
            listTableView.restore()
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
                           
   @IBAction func settingButtonTapped(_ sender: UIButton) {
       self.presentSheetViewController(UnitsVC.self, storyboard: Storyboards.main, height: 230) { vc in
           vc.delegate = self
       }
    }
    
}

// MARK: - TableView Delegates
extension WeatherListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherListTableCell.Id, for: indexPath) as! WeatherListTableCell
        cell.configure(model: forecastArray[indexPath.row])
        return cell
    }
    
    
}

extension WeatherListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentViewController(WeatherDetailVC.self, storyboard: Storyboards.main) { vc in
            vc.delegate = self
            vc.forecastId = self.forecastArray[indexPath.row].city.id
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return nil
        } else {
            var actions = [UIContextualAction]()
            
            let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
                /// delete forecast item
                if CoredataManager.shared.deleteForecast(byID: Int64(self?.forecastArray[indexPath.row].city.id ?? 0)) {
                    
                    self?.forecastArray.remove(at: indexPath.row)
                    self?.listTableView.reloadData()
                }
                completion(true)
            }
            
            //delete button configuration
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
            delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate)
            delete.backgroundColor = .systemBackground
            
            actions.append(delete)
            
            let config = UISwipeActionsConfiguration(actions: actions)
            config.performsFirstActionWithFullSwipe = false
            
            return config
        }
    }
}

// MARK: - LocationManager Delegates
extension WeatherListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // fetch city name using coordinates
        locationManager.stopUpdatingLocation()
        
        if !currentLocFetched {
            currentLocFetched = true
            locations.last?.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                
                ///get weather forecast details
                self.getWeatherForecastOfCurrentLocation(cityName: city)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocation()
    }
    
    /// Check app's Location access permission
    func checkLocation()  {
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
                vc.delegate = self
                vc.forecastId =  weather.id
            }
        }
    }
}

//WeatherDetailVCDelegate Delegates
extension WeatherListVC: WeatherDetailVCDelegate {
    func newLocationAdded() {
        getAllDBForecasts(update: true)
    }
}

//UnitsVCDelegate Delegates
extension WeatherListVC: UnitsVCDelegate {
    func itemSelected() {
        listTableView.reloadData()
    }
}
