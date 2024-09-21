//
//  SearchLocationtVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit
import MapKit

protocol SearchLocationtVCDelegate: AnyObject {
    func weatherDetailFetched(weather: Weather)
}

class SearchLocationtVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    private let viewModel = WeatherViewModel()
    weak var delegate: SearchLocationtVCDelegate?
    private let searchCompleter = MKLocalSearchCompleter()
    private var locationArray: [MKLocalSearchCompletion] = []
    private var activityIndicator: ActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Initial settings
    private func configure() {
        searchTextField.becomeFirstResponder()
        activityIndicator = ActivityIndicator(view: self.view)
        listTableView?.separatorInset = .zero
        listTableView?.layoutMargins = .zero
        searchCompleter.delegate = self
    }
    
    /// API call for weather details using location coordinates
    private func getWeatherWithCoordinates(address: MKLocalSearchCompletion) {
        
        // get coordinates from address
       let searchRequest = MKLocalSearch.Request(completion: address)
        searchRequest.naturalLanguageQuery = address.title
        let search = MKLocalSearch(request: searchRequest)
       search.start { response, error in
            if let response = response,
               let firstPlacemark = response.mapItems.first?.placemark {
                let coordinate = firstPlacemark.coordinate
               
                // API call for weather details using location coordinates
                self.viewModel.getWeatherDetail(lat: String(coordinate.latitude), lng: String(coordinate.longitude)) { model in
                    self.activityIndicator.stopAnimaton()
                    
                    /// check weather details available and send to SearchLocationtVCDelegate
                    if let weatherDetails = model, weatherDetails.cityName != "" {
                        self.delegate?.weatherDetailFetched(weather: weatherDetails)
                        self.dismiss(animated: false)
                    } else {
                        Toast.show(AlertMessages.weatherEmptyAlert)
                    }
                }
            } else {
                self.activityIndicator.stopAnimaton()
                Toast.show(AlertMessages.weatherEmptyAlert)
            }
        }
    }
    
    /// API call for weather details using location name
    private func getWeatherWithLocationName(address: MKLocalSearchCompletion) {
        activityIndicator.startAnimaton()
        viewModel.getWeatherDetail(location: address.title) { model in
            
            /// check weather details available and send to SearchLocationtVCDelegate
            /// If weather data not available, try with coordinates
            if let weatherDetails = model, weatherDetails.cityName != "" {
                self.activityIndicator.stopAnimaton()
                self.delegate?.weatherDetailFetched(weather: weatherDetails)
                self.dismiss(animated: false)
            } else {
                self.getWeatherWithCoordinates(address: address)
            }
        }
    }
}

// MARK: - MKLocalSearchCompleter Delegate
extension SearchLocationtVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationArray = completer.results
        listTableView.reloadData()
        
        if locationArray.count == 0 {
            listTableView.setEmptyMessage(AlertMessages.searchEmptyAlert)
        } else {
            listTableView.restore()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - TableView Delegate
extension SearchLocationtVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: LocationTableCell.Id, for: indexPath) as! LocationTableCell
        cell.titleLabel.text = locationArray[indexPath.row].title
        return cell
    }
}

extension SearchLocationtVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///get weather details using location name
        let address = locationArray[indexPath.row]
        self.getWeatherWithLocationName(address: address)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - TextField Delegate
extension SearchLocationtVC: UITextFieldDelegate {
    func  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            if updatedText.count > 1 {
                searchCompleter.queryFragment = updatedText
               
                let region = MKCoordinateRegion(.world)
                searchCompleter.region = region
            } else {
                locationArray.removeAll()
                listTableView.reloadData()
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        locationArray.removeAll()
        listTableView.reloadData()
        return true
    }
}
