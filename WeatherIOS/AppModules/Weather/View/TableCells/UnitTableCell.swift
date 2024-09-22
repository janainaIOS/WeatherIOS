//
//  UnitTableCell.swift
//  WeatherIOS
//
//  Created by Janaina A on 22/09/2024.
//

import UIKit

class UnitTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(unit: Unit, index: Int, selectedRow: Int) {

        iconImageView.image = index == selectedRow ? UIImage(systemName: "checkmark.circle.fill") : nil
        titleLabel.text = unit.rawValue
    }
}

