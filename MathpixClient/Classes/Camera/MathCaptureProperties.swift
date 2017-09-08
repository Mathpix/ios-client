//
//  MathCaptureProperties.swift
//  Pods
//
//  Created by Дмитрий Буканович on 01.09.17.
//
//

import Foundation

/**
 *  The struct to incapsulate `MathCaptureViewController` properties.
 */
public struct MathCaptureProperties {
    
    /**
     *  The UI type of invoke capture event.
     */
    public enum CaptureType {
        /// Tap gesture is used to capture image.
        case gesture
        /// Shutter button is used to capture image.
        case button
    }
    
    /**
     *  The UI buttons in `MathCaptureViewController`.
     */
    public enum MathCaptureButton {
        /// Back button
        case back
        /// Flash button
        case flash
    }
    
    /// The color of crop overlay bounds.
    internal let cropColor: UIColor
    
    /// The icon of shutter button.
    internal let shutterIcon : UIImage?
    
    /// The icon of flash button.
    internal let flashIcon : UIImage?
    
    /// The icon of back button.
    internal let backIcon : UIImage?
    
    /// The icon of cancel request button.
    internal let cancelIcon : UIImage?
    
    /// The type of `RecognitionAnimator`. Used to provide animation for recognition process.
    internal let animatorType : RecognitionAnimator.Type
    
    /// The text of info label under crop area.
    internal let infoLabelText: String
    
    /// The type of UI capture action.
    internal let captureType: CaptureType
    
    /// The buttons which will be presented in instantiated `MathCaptureViewController`.
    internal let requiredButtons: [MathCaptureButton]
    
    /// The size of `shutter` button.
    internal let bigButtonSize: CGSize
    
    /// The size of buttons.
    internal let smallButtonSize: CGSize
    
    /// The crop area insets.
    internal let cropAreaInsets: UIEdgeInsets
    
    
    public init(shutterIcon: UIImage? = nil,
                flashIcon: UIImage? = nil,
                backIcon: UIImage? = nil,
                cancelIcon: UIImage? = nil,
                infoLabelText: String? = nil,
                captureType: CaptureType? = nil,
                requiredButtons: [MathCaptureButton]? = nil,
                cropColor: UIColor? = nil,
                animatorType: RecognitionAnimator.Type? = nil,
                bigButtonSize: CGSize? = nil,
                smallButtonSize: CGSize? = nil,
                cropAreaInsets: UIEdgeInsets? = nil)
    {
        
        self.shutterIcon = shutterIcon ?? MathpixClient.getImageFromResourceBundle(name: "shutter_icon")
        self.flashIcon = flashIcon
        self.backIcon = backIcon ?? MathpixClient.getImageFromResourceBundle(name: "back_icon")
        self.cancelIcon = cancelIcon ?? MathpixClient.getImageFromResourceBundle(name: "close_icon")
        self.animatorType = animatorType ?? QuoraAnimator.self
        self.infoLabelText = infoLabelText ?? "Tap anywhere to take a picture"
        self.captureType = captureType ?? CaptureType.gesture
        self.requiredButtons = requiredButtons ?? [.back, .flash]
        self.bigButtonSize = bigButtonSize ?? CGSize(width: 60, height: 60)
        self.smallButtonSize = smallButtonSize ?? CGSize(width: 40, height: 40)
        self.cropColor = cropColor ?? UIColor.white
        self.cropAreaInsets = cropAreaInsets ?? UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
  }



