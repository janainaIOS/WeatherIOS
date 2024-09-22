//
//  WeatherListTableCell.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

class WeatherListTableCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptnLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var lowHighTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initializaton code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: Forecast) {
        locationNameLabel.text = model.city.name
        //get current time using timezone
        dateLabel.text = model.isHome ? "My Location • 🏠︎ Home" : model.city.timezone.getCurrentTime(outputFormat: .hmma)
        descriptnLabel.text = model.list.first?.descriptn.first?.main ?? ""
        let currentTemp = appUnit == .metric ? model.list.first?.temparature?.temp ?? 0 : model.list.first?.temparature?.temp?.celsiusToFahrenheit()
        currentTempLabel.text = String(format: "%.0f", currentTemp ?? 0) + "°"
        let maxTemp = appUnit == .metric ? model.list.first?.temparature?.maxTemp ?? 0 : model.list.first?.temparature?.maxTemp?.celsiusToFahrenheit()
        let minTemp = appUnit == .metric ? model.list.first?.temparature?.minTemp ?? 0 : model.list.first?.temparature?.minTemp?.celsiusToFahrenheit()
        lowHighTempLabel.text = "H:\(String(format: "%.0f", maxTemp ?? 0))°  L:\(String(format: "%.0f", minTemp ?? 0))°"
    }
    
}

