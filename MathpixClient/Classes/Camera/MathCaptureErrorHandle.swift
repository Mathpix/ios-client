//
//  MathCaptureErrorHandle.swift
//  Pods
//
//  Created by Дмитрий Буканович on 09.09.17.
//
//

import Foundation

protocol MathCaptureErrorHandle {
    func handle(_ error: Error)
}


extension MathCaptureViewController : MathCaptureErrorHandle  {
    func handle(_ error: Error) {
        if let error = error as? NetworkError {
            handleNetworkError(error)
        } else if let error = error as? RecognitionError {
            handleRecognitionError(error)
        } else {
            let title = NSLocalizedString("Error capture", comment: "")
            let message = NSLocalizedString("Capture image error", comment: "")
            // alert error
            self.alertError(title: title, error: message)
        }
    }
    
    func handleNetworkError(_ error: Error) {
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .notReachedServer:
                let title = NSLocalizedString("Timeout error", comment: "")
                let message = NSLocalizedString("Send image timeout, try again later", comment: "")
                self.alertError(title: title, error: message)
            case .notConnectedToInternet:
                let title = NSLocalizedString("Network error", comment: "")
                let message = NSLocalizedString("No internet connection", comment: "")
                self.alertError(title: title, error: message)
            default:
                break
            }
        }
        
    }
    
    // Example of recognition error handling
    func handleRecognitionError(_ error: Error) {
        
        if let recognitionError = error as? RecognitionError {
            switch recognitionError {
            case .failedParseJSON:
                let title = NSLocalizedString("Error parse", comment: "")
                let message = NSLocalizedString("Error parse json", comment: "")
                // alert error
                self.alertError(title: title, error: message)
            case .notMath(let message):
                let resultError = NSError(domain: "localhost", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
                // display error under crop area
                self.onDisplayErrorEventually(resultError)
            case .invalidCredentials:
                let title = NSLocalizedString("Error credintials", comment: "")
                let message = NSLocalizedString("Invalid credentials", comment: "")
                self.alertError(title: title, error: message)
            }
        }
    }
    
    
    func alertError(title: String, error: String, completionBlock: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionBlock?()
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }

}
