//
//  WeatherDetailVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

class WeatherDetailVC: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    private let viewModel = WeatherViewModel()
    private var activityIndicator: ActivityIndicator!
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Initial settings
    private func configure() {
        activityIndicator = ActivityIndicator(view: self.view)
        getforcastDetails()
        cityNameLabel.text = forecast?.city?.name
        /// Hide add button if a weather item exist in database
        addButton.isHidden = CoredataManager.shared.checkDuplicateForecastByID(id: Int64(forecast?.city?.id ?? 0))
        /// set background image based on day or night
        bgImageView.image = isDayTime(sunrise: forecast?.city?.sunrise ?? 0, sunset: forecast?.city?.sunset ?? 0) ? .bgMorning : .bgNight
        
        
    }
    
    /// API call for forcast details using location coordinates
    private func getforcastDetails() {
        activityIndicator.startAnimaton()
        viewModel.getforecastDetails(lat: String(forecast?.city?.coord?.latitude ?? 0), lng: String(forecast?.city?.coord?.latitude ?? 0)) { model in
            self.activityIndicator.stopAnimaton()
            self.forecast = model
        }
    }
    
    /// Determines if the current time is day or night based on sunrise and sunset times.
    private func isDayTime(sunrise: Double, sunset: Double) -> Bool {
        // Convert the current time to Unix timestamp
        let currentTime = Date().timeIntervalSince1970
        
        // Check if the current time is between sunrise and sunset
        return currentTime >= sunrise && currentTime <= sunset
    }
    
    // MARK: - Button Actions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimaton()
        if let forecastData = forecast {
            CoredataManager.shared.insertOrUpdateForecast(forecast: forecastData) { tatus in
                self.activityIndicator.stopAnimaton()
                self.dismiss(animated: true)
                
            }
        }
    }
}
