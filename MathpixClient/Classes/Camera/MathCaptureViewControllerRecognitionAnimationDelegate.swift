//
//  MathCaptureViewControllerDelegate.swift
//  Pods
//
//  Created by Дмитрий Буканович on 08.09.17.
//
//

import Foundation


@objc
public protocol MathCaptureViewControllerRecognitionAnimationDelegate {
    @objc optional func willStartAnimateRecognition()
    @objc optional func didStartAnimateRecognition()
    @objc optional func willEndAnimateRecognition()
    @objc optional func didEndAnimateRecognition()
}
