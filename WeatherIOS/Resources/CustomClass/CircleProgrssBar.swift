//
//  CircleProgrssBar.swift
//  WeatherIOS
//
//  Created by Janaina A on 22/09/2024.
//

import UIKit

// MARK: - Line Cap Enum

public enum LineCap : Int{
    case round, butt, square
    
    public func style() -> CAShapeLayerLineCap {
        switch self {
        case .round:
            return CAShapeLayerLineCap.round
        case .butt:
            return CAShapeLayerLineCap.butt
        case .square:
            return CAShapeLayerLineCap.square
        }
    }
}

// MARK: - Orientation Enum

public enum Orientation: Int  {
    case left, top, right, bottom
    
}

@IBDesignable
open class CircleProgrssBar: UIView {
    //Half circle MKMagneticProgress
    
    // MARK: - Variables
    private let titleLabelWidth: CGFloat = 100
    private let percentLabel = UILabel(frame: .zero)
    @IBInspectable open var titleLabel = UILabel(frame: .zero)
    
    // Stroke background color
    @IBInspectable open var clockwise: Bool = true {
        didSet {
            layoutSubviews()
        }
    }
    
    // Stroke background color
    @IBInspectable open var backgroundShapeColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            updateShapes()
        }
    }
    
    // Progress stroke color
    @IBInspectable open var progressShapeColor: UIColor = .blue {
        didSet {
            updateShapes()
        }
    }
    
    // Line width
    @IBInspectable open var lineWidth: CGFloat = 8.0 {
        didSet {
            updateShapes()
        }
    }
    
    // Space value
    @IBInspectable open var spaceDegree: CGFloat = 45.0 {
        didSet {
            if spaceDegree < 45.0 {
                spaceDegree = 45.0
            }
            
            if spaceDegree > 135.0 {
                spaceDegree = 135.0
            }
            
            layoutSubviews()
            updateShapes()
        }
    }
    
    // The progress shapes line width will be the `line width` minus the `inset`.
    @IBInspectable open var inset: CGFloat = 0.0 {
        didSet {
            updateShapes()
        }
    }
    
    // The progress percentage label(center label) format
    @IBInspectable open var percentLabelFormat: String = "%.f %%" {
        didSet {
            percentLabel.text = String(format: percentLabelFormat, progress * 100)
        }
    }
    
    @IBInspectable open var percentColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            percentLabel.textColor = percentColor
        }
    }
    
    // progress text (progress bottom label)
    @IBInspectable open var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable open var titleColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    // progress text (progress bottom label)
    @IBInspectable open var font: UIFont = .systemFont(ofSize: 13) {
        didSet {
            titleLabel.font = font
            percentLabel.font = font
        }
    }
    
    // progress Orientation
    open var orientation: Orientation = .bottom {
        didSet {
            updateShapes()
        }
    }
    
    // Progress shapes line cap.
    open var lineCap: LineCap = .round {
        didSet {
            updateShapes()
        }
    }
    
    // Returns the current progress.
    @IBInspectable open private(set) var progress: CGFloat {
        set {
            progressShape?.strokeEnd = newValue
        }
        get {
            return progressShape.strokeEnd
        }
    }
    
    // Duration for a complete animation from 0.0 to 1.0.
    open var completeDuration: Double = 2.0
    
    private var backgroundShape: CAShapeLayer!
    private var progressShape: CAShapeLayer!
    private var progressAnimation: CABasicAnimation!
    
    // MARK: - Init
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        backgroundShape = CAShapeLayer()
        backgroundShape.fillColor = nil
        backgroundShape.strokeColor = backgroundShapeColor.cgColor
        layer.addSublayer(backgroundShape)
        
        progressShape = CAShapeLayer()
        progressShape.fillColor = nil
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd = 0.1
        layer.addSublayer(progressShape)
        
        progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        percentLabel.frame = self.bounds
        percentLabel.textAlignment = .center
        self.addSubview(percentLabel)
        //to show percentage 
      //  percentLabel.text = String(format: "%.1f%%", progress * 100)
        
        titleLabel.frame = CGRect(x: (self.bounds.size.width - titleLabelWidth) / 2, y: self.bounds.size.height - 21, width: titleLabelWidth, height: 21)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.contentScaleFactor = 0.3
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
    }
    
    // MARK: - Progress Animation
    public func setProgress(progress: CGFloat, animated: Bool = true) {
        if progress > 1.0 {
            return
        }
        
        var start = progressShape.strokeEnd
        if let presentationLayer = progressShape.presentation() {
            if let count = progressShape.animationKeys()?.count, count > 0 {
                start = presentationLayer.strokeEnd
            }
        }
        
        let duration = abs(Double(progress - start)) * completeDuration
        percentLabel.text = String(format: percentLabelFormat, progress * 100)
        progressShape.strokeEnd = progress
        
        if animated {
            progressAnimation.fromValue = start
            progressAnimation.toValue = progress
            progressAnimation.duration = duration
            progressShape.add(progressAnimation, forKey: progressAnimation.keyPath)
        }
    }
    
    // MARK: - Layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundShape.frame = bounds
        progressShape.frame = bounds
        
        let rect = rectForShape()
        backgroundShape.path = pathForShape(rect: rect).cgPath
        progressShape.path = pathForShape(rect: rect).cgPath
        
        titleLabel.frame = CGRect(x: (self.bounds.size.width - titleLabelWidth) / 2, y: self.bounds.size.height - 50, width: titleLabelWidth, height: 42)
        
        updateShapes()
        percentLabel.frame = self.bounds
    }
    
    private func updateShapes() {
        backgroundShape?.lineWidth = lineWidth
        backgroundShape?.strokeColor = backgroundShapeColor.cgColor
        backgroundShape?.lineCap = lineCap.style()
        
        progressShape?.strokeColor = progressShapeColor.cgColor
        progressShape?.lineWidth = lineWidth - inset
        progressShape?.lineCap = lineCap.style()
        
        switch orientation {
        case .left:
            titleLabel.isHidden = true
            self.progressShape.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1.0)
        case .right:
            titleLabel.isHidden = true
            self.progressShape.transform = CATransform3DMakeRotation(CGFloat.pi * 1.5, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi * 1.5, 0, 0, 1.0)
        case .bottom:
            titleLabel.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: { [weak self] in
                if let temp = self {
                    temp.titleLabel.frame = CGRect(x: (temp.bounds.size.width - temp.titleLabelWidth) / 2, y: temp.bounds.size.height - 50, width: temp.titleLabelWidth, height: 42)
                }
            }, completion: nil)
            self.progressShape.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1.0)
        case .top:
            titleLabel.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: { [weak self] in
                if let temp = self {
                    temp.titleLabel.frame = CGRect(x: (temp.bounds.size.width - temp.titleLabelWidth) / 2, y: 0, width: temp.titleLabelWidth, height: 42)
                }
            }, completion: nil)
            self.progressShape.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1.0)
        }
    }
    
    // Returns the correct shape rect
    private func rectForShape() -> CGRect {
        let lineWidth = max(self.lineWidth, backgroundShape.lineWidth)
        var rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        
        switch orientation {
        case .bottom:
            rect = rect.insetBy(dx: 0, dy: -bounds.size.height * 0.1)
        case .top:
            rect = rect.insetBy(dx: 0, dy: bounds.size.height * 0.1)
        default:
            break
        }
        
        return rect
    }
    
    // Return the circle path.
    private func pathForShape(rect: CGRect) -> UIBezierPath {
        let startAngle: CGFloat = .pi // Start at the left
        let endAngle: CGFloat = clockwise ? 0 : .pi * 2 // Draw in a half-circle pattern
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}
