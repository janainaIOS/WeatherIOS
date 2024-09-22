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
        // dateLabel.text = model.dateTime.formatDate(inputFormat: .yyyyMMddHHmmss, outputFormat: .eee, today: true)
        currentTempLabel.text = String(format: "%.0f", model.list.first?.temparature?.temp ?? 0) + "°"
        lowHighTempLabel.text = "H:\(String(format: "%.0f", model.list.first?.temparature?.maxTemp ?? 0))°  L:\(String(format: "%.0f", model.list.first?.temparature?.minTemp ?? 0))°"
    }
    
}
