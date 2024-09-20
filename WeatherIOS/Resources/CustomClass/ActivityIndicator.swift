//
//  ActivityIndicator.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

class ActivityIndicator: NSObject {
    let size: CGFloat = 65.0
    var activityIndicator: UIActivityIndicatorView! = nil
    var overlay: UIView! = nil
    let superView: UIView!
    
    init(view: UIView) {
        superView = view
        self.overlay = UIView(frame: CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height))
        self.overlay.backgroundColor = UIColor .black
        self.overlay.alpha = 0.5
        let activityframe = CGRect(x:view.frame.size.width/2-(size/2), y:view.frame.size.height/2-(size/2), width:size, height:size)
        self.activityIndicator = UIActivityIndicatorView(frame: activityframe)
        self.activityIndicator.color = .white
        self.activityIndicator.style = .large
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimaton() {
        self.superView .addSubview(self.overlay)
        self.superView .addSubview(self.activityIndicator)
        activityIndicator .startAnimating()
    }
    
    func stopAnimaton() {
        self.overlay .removeFromSuperview()
        activityIndicator .stopAnimating()
    }
}
