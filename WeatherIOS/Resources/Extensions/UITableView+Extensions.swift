//
//  UITableView+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

extension UITableView {
    /// Register a cell from external xib into a table instance.
    func register(_ nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /// To show placeholder text/image in tableview if date is empty
    func setEmptyMessage(_ message: String, image: UIImage? = nil) {
        let view = self.getPlaceholderView(message: message, image: image)
        self.backgroundView = view
    }
    ///To remove placeholder text
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableViewCell {
    static var Id: String {
        String(describing: self)
    }
}

