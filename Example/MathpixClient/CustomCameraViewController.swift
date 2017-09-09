//
//  CustomCameraViewController.swift
//  MathpixClient
//
//  Created by Дмитрий Буканович on 08.09.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MathpixClient

class CustomCameraViewController: MathCaptureViewController {
    
    var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCallbacks()
        // Set delegate to get animation messages
        self.delegate = self
        // Add your UI elements here
        
        
        menuButton = UIButton(forAutoLayout: ())
        menuButton.setTitle("Menu", for: .normal)
        menuButton.addTarget(self, action: #selector(CustomCameraViewController.onMenu), for: .touchUpInside)
        
        view.addSubview(menuButton)
        menuButton.autoPin(toTopLayoutGuideOf: self, withInset: 8)
        menuButton.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -16)

    }
    
    // Override this method to setup custom init properties. Do not call super.
    override func setupProperties() {
        // customize capture controller
        let properties = MathCaptureProperties(captureType: .button,
                                               requiredButtons: [],
                                               cropColor: UIColor.red)
        // set custom properties
        self.properties = properties
        self.outputFormats = [FormatLatex.simplified, FormatWolfram.on]
        
        
    }
    
    // Set crop area callback
    func setupCallbacks() {
        regionSelectedCallback = {
            print("region selected")
        }
        
        regionDraggingBeganCallback = {
            print("region draggin began")
        }
        
        regionDraggingCallback = { point in
            print("destination \(point)")
        }
    }
    
    // Override this method to set your controlls enabled/disabled when recognition in process.
    override func controlStateChanged(isEnabled: Bool) {
        print("control state \(isEnabled)")
        menuButton.isEnabled = isEnabled
    }
    
    
    
    // MARK: - Actions
    
    func onMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Action 1", style: .default, handler: { (_) in
            print("Action 1")
        }))
        alert.addAction(UIAlertAction(title: "Action 2", style: .default, handler: { (_) in
            print("Action 2")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    override func didRecieve(error: Error?, result: RecognitionResult?) {
        print("did recieve result \(result.debugDescription)")
    }
    
    
    

}

extension CustomCameraViewController: MathCaptureViewControllerRecognitionAnimationDelegate {
    func willStartAnimateRecognition() {
        print("willStartAnimateRecognition")
        menuButton.isHidden = true
    }
    
    func didStartAnimateRecognition() {
         print("didStartAnimateRecognition")
    }
    
    func willEndAnimateRecognition() {
         print("willEndAnimateRecognition")
    }
    
    func didEndAnimateRecognition() {
        print("didEndAnimateRecognition")
        menuButton.isHidden = false
    }
}



