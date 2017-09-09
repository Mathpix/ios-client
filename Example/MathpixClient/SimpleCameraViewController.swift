//
//  SimpleCameraViewController.swift
//  MathpixClient
//
//  Created by Дмитрий Буканович on 08.09.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MathpixClient

class SimpleCameraViewController: UIViewController {
    @IBOutlet weak var outputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    @IBAction func onLaunchCamera(_ sender: Any) {
        // Setup camera properties
        let properties = MathCaptureProperties(captureType: .gesture,
                                               requiredButtons: [.flash, .back],
                                               cropColor: UIColor.green,
                                               errorHandling: true)
        
        // Launch camera with back and completion blocks
        MathpixClient.launchCamera(source: self,
                                   outputFormats: [FormatLatex.simplified],
                                   withProperties: properties,
                                   completion:
            { (error, result) in
                self.outputTextView.text = result.debugDescription + "  " + (error?.localizedDescription ?? "")
        })
    }

 
}
