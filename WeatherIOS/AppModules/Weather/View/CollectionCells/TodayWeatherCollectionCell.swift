//
//  TodayWeatherCollectionCell.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import UIKit

class TodayWeatherCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func configure(model: Weather) {
        timeLabel.text = model.dateTime.formatDate(inputFormat: .yyyyMMddHHmmss, outputFormat: .ha)
        
        if let weatherCondition = WeatherCondition(rawValue: model.descriptn.first?.main ?? "") {
            iconImageView.image = UIImage(systemName: weatherCondition.iconName)
        }
        let currentTemp = appUnit == .metric ? model.temparature?.temp ?? 0 : model.temparature?.temp?.celsiusToFahrenheit()
        tempLabel.text = String(format: "%.0f", currentTemp ?? 0) + "°"
    }
}
