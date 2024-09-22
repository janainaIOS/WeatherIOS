//
//  WeeklyWeatherTableCell.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import UIKit

class WeeklyWeatherTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(model: Weather) {
        dateLabel.text = model.dateTime.formatDate(inputFormat: .yyyyMMddHHmmss, outputFormat: .eee, today: true)
        if let weatherCondition = WeatherCondition(rawValue: model.descriptn.first?.main ?? "") {
            iconImageView.image = UIImage(systemName: weatherCondition.iconName)
        }
        
        let minTemp = appUnit == .metric ? model.temparature?.minTemp ?? 0 : model.temparature?.minTemp?.celsiusToFahrenheit()
        let maxTemp = appUnit == .metric ? model.temparature?.maxTemp ?? 0 : model.temparature?.maxTemp?.celsiusToFahrenheit()
        minTempLabel.text = String(format: "%.0f", minTemp ?? 0) + "°"
        maxTempLabel.text = String(format: "%.0f", maxTemp ?? 0) + "°"
    }
}
