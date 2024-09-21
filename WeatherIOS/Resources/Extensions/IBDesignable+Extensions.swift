//
//  IBDesignable+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

@IBDesignable extension UIView {
    ///To add boarder, corner radius for any view in storyboard
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1.0)
        /*
         startPoint = CGPoint(x: 0.25, y: 0.5) endPoint = CGPoint(x: 0.75, y: 0.5) - left (50%)to right
         startPoint = CGPoint(x: 0.0, y: 0.0) endPoint = CGPoint(x: 1.0, y: 1.0) - top(75%) to bottom
         startPoint = CGPoint(x: 0.5, y: 0.0) endPoint = CGPoint(x: 0.5, y: 1.0) - top(60%) to bottom
         startPoint = CGPoint(x: 0.3, y: 0.0) endPoint = CGPoint(x: 0.3, y: 0.8) - top(50%) to bottom
         */
    }
}

@IBDesignable extension UITableView {
    @IBInspectable
    var isEmptyRowsHidden: Bool {
        get {
            return tableFooterView != nil
        }
        set {
            if newValue {
                tableFooterView = UIView(frame: .zero)
            } else {
                tableFooterView = nil
            }
            separatorInset = .zero
            
        }
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
           get {
               return self.rightView?.frame.width ?? 0
           }
           set {
               let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
               self.rightView = paddingView
               self.rightViewMode = .always
           }
       }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        // Update the padding view height if the text field height changes
        if let paddingView = leftView {
            paddingView.frame.size.height = self.frame.height
        }
    }
}

extension UILabel {
    ///To add shadow for label in storyboard
    @IBInspectable var isShadowOnText: Bool {
        get {
            return self.isShadowOnText
        }
        set {
            guard (newValue as? Bool ?? false) else {
                return
            }
            
            if newValue {
                
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowRadius = 2.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.masksToBounds = false
            }
        }
    }
}
