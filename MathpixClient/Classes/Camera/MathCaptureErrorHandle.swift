//
//  MathCaptureErrorHandle.swift
//  Pods
//
//  Created by Дмитрий Буканович on 09.09.17.
//
//

import Foundation

/// Internal error handling
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
            let title = NSLocalizedString("Error capture title", comment: "")
            let message = NSLocalizedString("Error capture message", comment: "")
            // alert error
            self.alertError(title: title, error: message)
        }
    }
    
    func handleNetworkError(_ error: Error) {
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .notReachedServer:
                let title = NSLocalizedString("Error timeout title", comment: "")
                let message = NSLocalizedString("Error timeout message", comment: "")
                self.alertError(title: title, error: message)
            case .notConnectedToInternet:
                let title = NSLocalizedString("Error no connection tittle", comment: "")
                let message = NSLocalizedString("Error no connection message", comment: "")
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
                let title = NSLocalizedString("Error parse title", comment: "")
                let message = NSLocalizedString("Error parse message", comment: "")
                // alert error
                self.alertError(title: title, error: message)
            case .notMath(let message):
                let resultError = NSError(domain: "localhost", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
                // display error under crop area
                self.onDisplayErrorEventually(resultError)
            case .invalidCredentials:
                let title = NSLocalizedString("Error credintials title", comment: "")
                let message = NSLocalizedString("Error credintials messages", comment: "")
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
