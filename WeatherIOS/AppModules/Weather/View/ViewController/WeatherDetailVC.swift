//
//  WeatherDetailVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

protocol WeatherDetailVCDelegate: AnyObject {
    func newLocationAdded()
}

class WeatherDetailVC: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var descriptnLabel: UILabel!
    @IBOutlet weak var lowHighTempLabel: UILabel!
    @IBOutlet weak var descriptnDetailLabel: UILabel!
    @IBOutlet weak var todayWeatherCollectionView: UICollectionView!
    @IBOutlet weak var weeklyWeatherTableview: UITableView!
    @IBOutlet weak var weeklyWeatherTitleLabel: UILabel!
    @IBOutlet weak var weeklyTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sunriseValueLabel: UILabel!
    @IBOutlet weak var sunsetValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
  
    @IBOutlet weak var sunriseView: CircleProgrssBar!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    private let viewModel = WeatherViewModel()
    weak var delegate: WeatherDetailVCDelegate?
    private var activityIndicator: ActivityIndicator!
    private var forecast: Forecast?
    private var todayWeatherArray: [Weather] = []
    private var weeklyWeatherArray: [Weather] = []
    var forecastId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    /// Initial settings
    private func configure() {
        activityIndicator = ActivityIndicator(view: self.view)
        getforcastDetails()
    }
    
    /// Initial view settings
    private func configureView() {
        contentScrollView.isHidden = true
        addButton.isHidden = true
    }
    
    /// API call for forecast details using location id
    private func getforcastDetails() {
        activityIndicator.startAnimaton()
        viewModel.getforecastDetails(itemCount: 40, cityId: forecastId) { model in
            self.activityIndicator.stopAnimaton()
            if let forecastData = model, forecastData.city.name != "" {
                
                self.forecast = model
                self.showForecastView()
            }
        }
    }
    ///Show forecast view using forecast api's data
    private func showForecastView() {
        contentScrollView.isHidden = false
        
        /// Hide add button if a weather item exist in database
        addButton.isHidden = CoredataManager.shared.checkDuplicateForecastByID(id: Int64(forecast?.city.id ?? 0))
        
        /// set background image based on day or night
        bgImageView.image = isDayTime(sunrise: forecast?.city.sunrise ?? 0, sunset: forecast?.city.sunset ?? 0) ? .bgMorning : .bgNight
        
        cityNameLabel.text = forecast?.city.name
        let currentTemp = appUnit == .metric ? forecast?.list.first?.temparature?.temp ?? 0 : forecast?.list.first?.temparature?.temp?.celsiusToFahrenheit()
        currentTempLabel.text = String(format: "%.0f", currentTemp ?? 0) + "°"
        descriptnLabel.text = forecast?.list.first?.descriptn.first?.main
        let maxTemp = appUnit == .metric ? forecast?.list.first?.temparature?.maxTemp ?? 0 : forecast?.list.first?.temparature?.maxTemp?.celsiusToFahrenheit()
        let minTemp = appUnit == .metric ? forecast?.list.first?.temparature?.minTemp ?? 0 : forecast?.list.first?.temparature?.minTemp?.celsiusToFahrenheit()
        lowHighTempLabel.text = "H:\(String(format: "%.0f", maxTemp ?? 0))°   L:\(String(format: "%.0f", minTemp ?? 0))°"
        descriptnDetailLabel.text = "\(descriptnLabel.text ?? "") conditions will continue for the rest of the day. Wind gusts are up to \(forecast?.list.first?.wind?.speed ?? 0) m/s."
        sunriseValueLabel.text = forecast?.city.sunrise.formatDateString(outputFormat: .hmma, timeZone: forecast?.city.timezone ?? 0)
        sunsetValueLabel.text = "Sunset: " + (forecast?.city.sunset.formatDateString(outputFormat: .hmma, timeZone: forecast?.city.timezone ?? 0) ?? "")
        humidityValueLabel.text = "\(String(format: "%.0f", forecast?.list.first?.temparature?.humidity ?? 0))%"
        pressureValueLabel.text = "\(String(format: "%.0f", forecast?.list.first?.temparature?.pressure ?? 0)) hPa"
        windValueLabel.text = "\(String(format: "%.0f", forecast?.list.first?.wind?.speed ?? 0)) m/s"
       
        //sunrise half circle view configuration
        if let timeZone = TimeZone(secondsFromGMT: forecast?.city.timezone ?? 0) {
            let sunriseTime = forecast?.city.sunrise.formatDate() ?? Date()
            let sunsetTime = forecast?.city.sunset.formatDate() ?? Date()
            
            let totalDuration = sunsetTime.timeIntervalSince(sunriseTime)
            if let currentDate = Date().formatLocationTimeZone(locationTimeZone: timeZone) {
                let elapsedDuration = currentDate.timeIntervalSince(sunriseTime)
                let progress = max(0.0, min(CGFloat(elapsedDuration / totalDuration), 1.0))
                sunriseView.setProgress(progress: progress, animated: true)
                sunriseView.orientation = .bottom
            }
            sunriseTimeLabel.text = forecast?.city.sunrise.formatDateString(outputFormat: .hmma, timeZone: forecast?.city.timezone ?? 0)
            sunsetTimeLabel.text = forecast?.city.sunset.formatDateString(outputFormat: .hmma, timeZone: forecast?.city.timezone ?? 0)
        }
        
        /// fetch today's forecast by date filter
        if let timeZone = TimeZone(secondsFromGMT: forecast?.city.timezone ?? 0) {
            todayWeatherArray = viewModel.getTodayForecasts(from: forecast?.list ?? [], timeZone: timeZone)
        }
        todayWeatherCollectionView.reloadData()
        
        /// fetch weather of each day
        weeklyWeatherArray = viewModel.getFirstWeatherForEachDate(from: forecast?.list ?? [], timezone: forecast?.city.timezone ?? 0)
        weeklyWeatherTableview.reloadData()
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
                self.delegate?.newLocationAdded()
            }
        }
    }
}

// MARK: - TableView Delegates
extension WeatherDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weeklyTableHeightConstraint.constant = CGFloat(55 * weeklyWeatherArray.count) + 40
        return weeklyWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyWeatherTableCell.Id, for: indexPath) as! WeeklyWeatherTableCell
        cell.configure(model: weeklyWeatherArray[indexPath.row])
        return cell
    }
    
    
}

extension WeatherDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

// MARK: - CollectionView Delegates
extension WeatherDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayWeatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherCollectionCell.Id, for: indexPath) as! TodayWeatherCollectionCell
        cell.configure(model: todayWeatherArray[indexPath.row])
        return cell
    }
}

extension WeatherDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension WeatherDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
}

