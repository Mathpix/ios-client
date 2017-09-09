//
//  RequestAnimatorQuora.swift
//  MathPix
//
//  Created by Дмитрий Буканович on 21.03.17.
//  Copyright © 2017 MathPix. All rights reserved.
//

import UIKit

class QuoraAnimator {
    
    fileprivate let dotOne = UIImageView()
    fileprivate let dotTwo = UIImageView()
    fileprivate let dotThree = UIImageView()
    
    fileprivate let container = UIView()
    
    fileprivate let containerHeight : CGFloat = 60
    fileprivate let containerWidth : CGFloat = 60
    fileprivate let dotSide : CGFloat = 15
    
    fileprivate var isAnimated = false
    
    required init() {
        
        self.container.autoSetDimension(.width, toSize: containerWidth, relation: .equal)
        self.container.autoSetDimension(.height, toSize: containerHeight, relation: .equal)
        
        self.prepareForAnimation()
    }
    
    fileprivate func prepareForAnimation() {
        let image = MathpixClient.getImageFromResourceBundle(name: "dot_blue")
        
        dotOne.image = image
        dotTwo.image = image
        dotThree.image = image
        
        dotOne.autoSetDimensions(to: CGSize(width: dotSide, height: dotSide))
        dotTwo.autoSetDimensions(to: CGSize(width: dotSide, height: dotSide))
        dotThree.autoSetDimensions(to: CGSize(width: dotSide, height: dotSide))
        
        self.container.addSubview(dotOne)
        self.container.addSubview(dotTwo)
        self.container.addSubview(dotThree)
        
        dotOne.autoPinEdge(.leading, to: .leading, of: self.container)
        dotOne.autoAlignAxis(.horizontal, toSameAxisOf: self.container)
        dotTwo.autoCenterInSuperview()
        dotThree.autoPinEdge(.trailing, to: .trailing, of: self.container)
        dotThree.autoAlignAxis(.horizontal, toSameAxisOf: self.container)
        
        setTransform()
    }
    
    fileprivate func setTransform() {
        // Make dots very small (practically invsisble) since
        // we want the animation to start from small to big.
        dotOne.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dotTwo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dotThree.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

    }
}


extension QuoraAnimator: RecognitionAnimator {
    
    var view : UIView  {
        return self.container
    }
    
    func beginAnimation() {
        
        if isAnimated {
            return
        }
        
        self.isAnimated = true

        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.dotOne.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.dotTwo.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.dotThree.transform = CGAffineTransform.identity
        }, completion: nil)
        
        
    }
    
    
    func finishAnimation() {
        
        self.dotOne.layer.removeAllAnimations()
        self.dotTwo.layer.removeAllAnimations()
        self.dotThree.layer.removeAllAnimations()
        
        setTransform()
        
        self.isAnimated = false
    }

}

