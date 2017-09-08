//
//  RequestAnimator.swift
//  MathPix
//
//  Created by Дмитрий Буканович on 22.03.17.
//  Copyright © 2017 MathPix. All rights reserved.
//

import Foundation

/**
 *  Provides animation for recognition process.
 */
public protocol RecognitionAnimator {
    /// This view will be added before start animation. Place animated objects in this view
    var view: UIView { get }
    /// Init method. Use to init all animated objects.
    init()
    /// This method invoked when recognition process did start.
    func beginAnimation()
    /// This method invoked when recognition process did finish.
    func finishAnimation()
}
