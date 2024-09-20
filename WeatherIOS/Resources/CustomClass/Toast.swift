//
//  Toast.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

class Toast: NSObject {
    
    static func show(_ message: String, duration: CGFloat = 2.0) {
        // get window
        guard let unwrappedWindow = Toast().getWindow() else {
            return
        }
        
        // Configure toast text label
        let messageLbl = UILabel()
        messageLbl.numberOfLines = 0
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 13)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = .lightGray
        
        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, unwrappedWindow.frame.width - 50)
        
        messageLbl.frame = CGRect(x: 25, y: unwrappedWindow.frame.height - 90, width: labelWidth + 30, height: textSize.height + 25)
        messageLbl.center.x = unwrappedWindow.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        
        // Add label to the view
        unwrappedWindow.addSubview(messageLbl)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            messageLbl.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: duration, options: .curveEaseOut, animations: {
                messageLbl.alpha = 0.0
            }, completion: {_ in
                messageLbl.removeFromSuperview()
            })
        })
    }
    
    func getWindow()-> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

