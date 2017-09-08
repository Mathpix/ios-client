//
//  CircularProgress.swift
//  MathPix
//
//  Created by Дмитрий Буканович on 28.11.16.
//  Copyright © 2016 MathPix. All rights reserved.
//

import UIKit

// MARK: - CircularProgress
@IBDesignable
open class CircularProgress: UIView {
    
    /**
     Current progress value. (0.0 - 1.0)
     */
    @IBInspectable open var progress: Double = 0.0 {
        didSet {
            let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
            progressView.update(progress: clipProgress)
            
            progressChanged?(clipProgress, self)
            delegate?.progressChanged(progress: clipProgress, circularProgress: self)
        }
    }
    
    /**
     Main progress line width.
     */
    @IBInspectable open var lineWidth: Double = 8.0 {
        didSet {
            progressView.shapeLayer.lineWidth = CGFloat(lineWidth)
        }
    }
    
    /**
     Guide progress line width.
     */
    @IBInspectable open var guideLineWidth: Double = 8.0 {
        didSet {
            guideView.shapeLayer.lineWidth = CGFloat(guideLineWidth)
        }
    }
    
    /**
     Progress guide bar color.
     */
    @IBInspectable open var guideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        didSet {
            guideLayer.backgroundColor = guideColor.cgColor
        }
    }
    
    /**
     Switch of progress guide view. If you set to `true`, progress guide view is enabled.
     */
    @IBInspectable open var showGuide: Bool = false {
        didSet {
            guideView.isHidden = !showGuide
            guideLayer.backgroundColor = showGuide ? guideColor.cgColor : UIColor.clear.cgColor
        }
    }
    
    /**
     Progress bar path. You can create various type of progress bar.
     */
    open var path: UIBezierPath? {
        didSet {
            progressView.shapeLayer.path = path?.cgPath
            guideView.shapeLayer.path = path?.cgPath
        }
    }
    
    /**
     Progress bar colors. You can set many colors in `colors` property, and it makes gradation color in `colors`.
     */
    open var colors: [UIColor] = [UIColor(rgba: 0x9ACDE7FF), UIColor(rgba: 0xE7A5C9FF)] {
        didSet {
            update(colors: colors)
        }
    }
    
    /**
     Progress start angle.
     */
    open var startAngle: Double = 0.0 {
        didSet {
            progressView.startAngle = startAngle
            guideView.startAngle = startAngle
        }
    }
    
    /**
     Progress end angle.
     */
    open var endAngle: Double = 0.0 {
        didSet {
            progressView.endAngle = endAngle
            guideView.endAngle = endAngle
        }
    }
    
    open var delegate: CircularProgressDelegate?
    
    /**
     Typealias of progressChangedClosure.
     */
    public typealias progressChangedHandler = (_ progress: Double, _ circularProgress: CircularProgress) -> Void
    
    /**
     This closure is called when set value to `progress` property.
     */
    fileprivate var progressChanged: progressChangedHandler?
    
    /**
     Main progress view.
     */
    fileprivate lazy var progressView: CircularShapeView = {
        let progressView = CircularShapeView(frame: self.bounds)
        progressView.shapeLayer.fillColor = UIColor.clear.cgColor
        progressView.shapeLayer.lineWidth = CGFloat(self.lineWidth)
        progressView.radius = self.radius
        progressView.shapeLayer.path = self.path?.cgPath
        progressView.shapeLayer.strokeColor = self.tintColor.cgColor
        return progressView
    }()
    
    /**
     Gradient mask layer of `progressView`.
     */
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer(layer: self.layer)
        gradientLayer.frame = self.progressView.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = self.progressView.shapeLayer
        gradientLayer.colors = self.colors
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    /**
     Guide view of `progressView`.
     */
    fileprivate lazy var guideView: CircularShapeView = {
        let guideView = CircularShapeView(frame: self.bounds)
        guideView.shapeLayer.fillColor = UIColor.clear.cgColor
        guideView.shapeLayer.lineWidth = CGFloat(self.guideLineWidth)
        guideView.radius = self.radius
        self.progressView.radius = self.radius
        guideView.shapeLayer.path = self.progressView.shapeLayer.path
        guideView.shapeLayer.strokeColor = self.tintColor.cgColor
        guideView.update(progress: 1.0)
        return guideView
    }()
    
    /**
     Mask layer of `progressGuideView`.
     */
    fileprivate lazy var guideLayer: CALayer = {
        let guideLayer = CAGradientLayer(layer: self.layer)
        guideLayer.frame = self.guideView.frame
        guideLayer.mask = self.guideView.shapeLayer
        guideLayer.backgroundColor = self.guideColor.cgColor
        guideLayer.zPosition = -1
        self.layer.addSublayer(guideLayer)
        return guideLayer
    }()
    
    private var radius: Double {
        return lineWidth >= guideLineWidth ? lineWidth : guideLineWidth
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setNeedsLayout()
        layoutIfNeeded()
        
        update(colors: colors)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /**
     Create `CircularProgress` with progress guide.
     
     - parameter frame: `CircularProgress` frame.
     - parameter showProgressGuide: If you set to `true`, progress guide view is enabled.
     */
    public init(frame: CGRect, showGuide: Bool) {
        super.init(frame: frame)
        self.showGuide = showGuide
        guideLayer.backgroundColor = showGuide ? guideColor.cgColor : UIColor.clear.cgColor
    }
    
    /**
     This closure is called when set value to `progress` property.
     
     - parameter completion: progress changed closure.
     */
    open func progressChanged(completion: @escaping progressChangedHandler) {
        progressChanged = completion
    }
    
    public func set(progress: Double, duration: Double) {
        let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
        progressView.update(progress: clipProgress, duration: duration)
        
        progressChanged?(clipProgress, self)
        delegate?.progressChanged(progress: clipProgress, circularProgress: self)
    }
    
    fileprivate func update(colors: [UIColor]) {
        gradientLayer.colors = colors.map {$0.cgColor}
        if colors.count == 1 {
            gradientLayer.colors?.append(colors.first!.cgColor)
        }
    }
    
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

public protocol CircularProgressDelegate {
    func progressChanged(progress: Double, circularProgress: CircularProgress)
}

// MARK: - CircularShapeView
class CircularShapeView: UIView {
    var startAngle = 0.0
    var endAngle = 0.0
    var radius = 0.0
    
    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update(progress: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if startAngle == endAngle {
            endAngle = startAngle + (Double.pi * 2)
        }
        
        shapeLayer.path = shapeLayer.path ?? layoutPath().cgPath
    }
    
    private func layoutPath() -> UIBezierPath {
        let halfWidth = CGFloat(frame.width / 2.0)
        return UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: (frame.width - CGFloat(radius)) / 2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
    }
    
    fileprivate func update(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        shapeLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
    
    fileprivate func update(progress: Double, duration: Double) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fromValue = shapeLayer.strokeEnd
        animation.toValue = progress
        shapeLayer.add(animation, forKey: "animateStrokeEnd")
        CATransaction.commit()
        shapeLayer.strokeEnd = CGFloat(progress)
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience public init(rgba: Int64) {
        let red   = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue  = CGFloat((rgba & 0x0000FF00) >> 8)  / 255.0
        let alpha = CGFloat( rgba & 0x000000FF)        / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
