//
//  UIView+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

extension UIView {
    func getPlaceholderView(message: String, image: UIImage? = nil) -> UIView {
        let overLay: UIView = UIView()
        overLay.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let placeholderImage = UIImageView()
        placeholderImage.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        placeholderImage.image = image
        let messageLabel = UILabel(frame: CGRect(x: 20, y:  placeholderImage.bounds.origin.y + 70, width: self.bounds.size.width - 40, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.sizeToFit()
        overLay.addSubview(messageLabel)
        messageLabel.backgroundColor = .clear
        overLay.addSubview(placeholderImage)
        placeholderImage.center.x = overLay.center.x
        placeholderImage.center.y = overLay.center.y
        messageLabel.center = overLay.center
        overLay.backgroundColor = .clear
        overLay.layoutIfNeeded()
        return overLay
    }
}

