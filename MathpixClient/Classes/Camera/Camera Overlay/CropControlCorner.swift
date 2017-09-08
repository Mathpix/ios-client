//
//  CropControlCorner.swift
//  SliderTest
//
//  Created by Gilbert Jolly on 30/04/2016.
//  Copyright © 2016 Gilbert Jolly. All rights reserved.
//

import Foundation

//Data structure to represent the directions of the lines at the corners
enum LineDirection {
    case up
    case down
    case left
    case right
    
    func endPoint() -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: 0, y: -1)
        case .down:
            return CGPoint(x: 0, y: 1)
        case .left:
            return CGPoint(x: -1, y: 0)
        case .right:
            return CGPoint(x: 1, y: 0)
        }
    }
}


//This class represents a corner
//It's is always centered on a corner
//It's only responsible for drawing two lines from its center, to show the touchable aree
class CropControlCorner: UIView {
    
    var color: UIColor = UIColor.white
    let lineDirections: [LineDirection]
    init(lineDirections: [LineDirection], color: UIColor){
        self.lineDirections = lineDirections
        self.color = color
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        for direction in lineDirections {
            let viewWidth = frame.width / 2
            let path = UIBezierPath()
            
            //Move path to start at centfler
            let center = CGPoint(x: viewWidth, y: viewWidth)
            path.move(to: center)
            
            //Add a line to the final point of the line,
            //calculated using the relative point returned by the enum
            let lineLength = frame.width / 3
            let relativeLineEnd = direction.endPoint()
            
            let xPoint = center.x + (relativeLineEnd.x * lineLength)
            let yPoint = center.y + (relativeLineEnd.y * lineLength)
            path.addLine(to: CGPoint(x: xPoint, y: yPoint))
            path.lineWidth = 10.0
            
            //Set color and stroke
            color.set()
            path.stroke()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
