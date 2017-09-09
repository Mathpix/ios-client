//
//  ViewController.swift
//  MathpixClient
//
//  Created by DmitriDevelopment on 08/29/2017.
//  Copyright (c) 2017 DmitriDevelopment. All rights reserved.
//

import UIKit
import MathpixClient

class RecognizeViewController: UIViewController {
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func onRecognize(_ sender: Any) {
        self.outputTextView.text = "recognition ..."
        // Recognize image with mathpix server
//        MathpixClient.recognize(image: UIImage(named: "equation")!, outputFormats: [FormatLatex.simplified, FormatWolfram.on]) { (error, result) in
//            print(result ?? error ?? "")
//            self.outputTextView.text = result.debugDescription
//        }
//        
        let vc = CustomCameraViewController()
        present(vc, animated: true, completion: nil)
    }
    
     
}

