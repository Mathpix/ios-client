//
//  CropControl.swift
//  SliderTest
//
//  Created by Gilbert Jolly on 30/04/2016.
//  Copyright © 2016 Gilbert Jolly. All rights reserved.
//
import PureLayout
import Foundation

class CropControl: UIView {
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var initialTouchOffset = CGPoint.zero
    var panStateCallback: ((_ state: UIGestureRecognizer.State) -> ())?
    var cropFrameDidChangedCallback: ((_ bottomCenter: CGPoint) -> ())?
    let imageOverlay = UIImageView()
    var boxOverlay : MPOverlayView?
    var color: UIColor = UIColor.white
    
    fileprivate var maxEdges : CGSize?
    fileprivate let cornersBorderMovement = UIEdgeInsets(top: 80, left: 0, bottom: 80, right: 0)
    
    fileprivate var defaultCropSize : CGSize {
        return CGSize(width: cornerLength * 7.0, height: cornerLength * 3.5)
    }
    
    //The length of each line from the corner (each corner control is double this size)
    let cornerLength :CGFloat = 40
    
    
    init(color: UIColor){
        super.init(frame: CGRect.zero)
        self.color = color
        setupView()
        setupCorners()
        setupSizeConstraints()
    }
    
    func setupView(){
        backgroundColor = UIColor.clear
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        addSubview(imageOverlay)
        imageOverlay.autoPinEdgesToSuperviewEdges()
        imageOverlay.isUserInteractionEnabled = false
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        // take superview bounds when exist only once and send to owner to layout
        if maxEdges?.height == 0 || maxEdges == nil {
            maxEdges = superview?.frame.size
            self.sendBottomBoundsToOwner()
        }
    }
    
    
    func setupSizeConstraints() {
        widthConstraint = autoSetDimension(.width, toSize: defaultCropSize.width)
        widthConstraint?.priority = UILayoutPriority.defaultHigh
        heightConstraint = autoSetDimension(.height, toSize: defaultCropSize.height)
        heightConstraint?.priority = UILayoutPriority.defaultHigh

    }
    
    func resetView(){
        imageOverlay.image = nil
        widthConstraint?.constant = defaultCropSize.width
        heightConstraint?.constant = defaultCropSize.height
        
        boxOverlay?.removeFromSuperview()
        self.sendBottomBoundsToOwner()
    }
    
    func displayBoxes(_ boxes: [AnyObject], callback: @escaping () -> ()){
        self.boxOverlay?.removeFromSuperview()
        
        let boxOverlay = MPOverlayView()
        addSubview(boxOverlay)
        boxOverlay.autoPinEdgesToSuperviewEdges()
        layoutIfNeeded()
        
        boxOverlay.backgroundColor = UIColor.clear
        boxOverlay.isUserInteractionEnabled = false
        boxOverlay.displayBoxes(boxes, completionCallback: callback)
        boxOverlay.isHidden = false
        boxOverlay.setNeedsDisplay()
        
        self.boxOverlay = boxOverlay
    }
    
    func setupCorners(){
        
        //Create corner views, defined by the edges they stick to, and the direction of the lines
        let topLeft = addControlToCornerWithEdges([.top, .left], lineDirections: [.down, .right])
        let topRight = addControlToCornerWithEdges([.top, .right], lineDirections: [.down, .left])
        let bottomLeft = addControlToCornerWithEdges([.bottom, .left], lineDirections: [.up, .right])
        let bottomRight = addControlToCornerWithEdges([.bottom, .right], lineDirections: [.up, .left])
        
        let corners = [topLeft, topRight, bottomLeft, bottomRight]
        for corner in corners {
            handleMovementForCorner(corner)
        }
    }
    
    //Stick the corner to the edges in pinEdges, tell the corners how to draw themselves
    func addControlToCornerWithEdges(_ pinEdges: [ALEdge], lineDirections: [LineDirection]) -> CropControlCorner {
        
        let controlCorner = CropControlCorner(lineDirections: lineDirections, color: color)
        addSubview(controlCorner)
        for edge in pinEdges {
            controlCorner.autoPinEdge(toSuperviewEdge: edge, withInset: -cornerLength)
        }
        //We double the corner length for the width, as the corner view is a box surrounding the corner
        controlCorner.autoSetDimensions(to: CGSize(width: cornerLength * 2, height: cornerLength * 2))
        
        return controlCorner
    }
    
    func handleMovementForCorner(_ corner: CropControlCorner) {
        let rec = UIPanGestureRecognizer()
        rec.addTarget(self, action: #selector(cornerMoved))
        rec.delegate = self
        corner.addGestureRecognizer(rec)
    }

    @objc func cornerMoved(_ gestureRecogniser: UIPanGestureRecognizer){
        if let corner = gestureRecogniser.view as? CropControlCorner {
            let viewCenter = CGPoint(x: frame.width/2, y: frame.height/2)
            let touchCenter = gestureRecogniser.location(in: self)
            
            
            //Store the initial offset of the touch, so we can get delta's later
            if gestureRecogniser.state == .began {
                let offsetX = corner.center.x - touchCenter.x
                let offsetY = corner.center.y - touchCenter.y
                initialTouchOffset = CGPoint(x: offsetX, y: offsetY)
                
                resetView()
            }

            //Set the width + height of the view based on the distance of the corner from the center
            guard let maxEdges = self.maxEdges else { return }
            let newCalculatedWidthValue = 2 * abs(touchCenter.x - viewCenter.x + initialTouchOffset.x)
            let maxWidthValue = maxEdges.width
            widthConstraint?.constant = max(min(newCalculatedWidthValue, maxWidthValue),cornerLength * 1.5)
            
            let newCalculatedHeightValue = 2 * abs(touchCenter.y - viewCenter.y + initialTouchOffset.y)
            let maxHeightValue = maxEdges.height - (cornersBorderMovement.top + cornersBorderMovement.bottom)
            heightConstraint?.constant = max(min(newCalculatedHeightValue, maxHeightValue), cornerLength * 1.5)
            
            self.sendBottomBoundsToOwner()
            
            //Let the owner know something happened
            self.panStateCallback?(gestureRecogniser.state)
        }
    }
    
    private func sendBottomBoundsToOwner() {
        guard let maxEdges = self.maxEdges else { return }
        let bottomPoint = CGPoint(x: self.center.x, y: maxEdges.height - (maxEdges.height - heightConstraint!.constant) / 2)
        self.cropFrameDidChangedCallback?(bottomPoint)
    }
    
    
    
    //Much of the corner control view is outside the bounds of this view,
    //We override hitTest to allow all of the view to recieve touches
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subView in subviews {
            let subViewPoint = subView.convert(point, from: self)
            if subView.point(inside: subViewPoint, with: event) && subView.isUserInteractionEnabled {
                return subView.hitTest(subViewPoint, with: event)
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CropControl: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.isUserInteractionEnabled
    }
}
