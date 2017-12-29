//
//  RecognitionService.swift
//  MathPix
//
//  Created by Sergey Glushchenko on 6/20/16.
//  Copyright © 2016 MathPix. All rights reserved.
//

import UIKit



class RecognitionService: NSObject {

    private var tasks : [AnyHashable : URLSessionDataTask] = [:]
    
    func currentSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        return configuration
    }
    
    /// Crop image with bounds
    class func cropImage(_ image: UIImage, bounds: CGRect) -> UIImage? {
        
        //Resize image with aspectRation to screen
        var rect = CGRect.zero
        let aspectX = image.size.width / bounds.size.width
        let aspectY = image.size.height / bounds.size.height
        var aspectRationImage: CGFloat = 0.0
        
        if aspectX > aspectY {
            aspectRationImage = bounds.size.width / bounds.size.height
            rect.origin.y = 0
            rect.size.height = image.size.height
            
            let widthOfImage = aspectRationImage * image.size.height
            let halfOriginalImage = image.size.width / 2
            let halfNewImage = widthOfImage / 2
            let offsetImageX = halfOriginalImage - halfNewImage
            rect.origin.x = offsetImageX
            rect.size.width = widthOfImage
        }
        else {
            aspectRationImage = bounds.size.height / bounds.size.width
            rect.origin.x = 0
            rect.size.width = image.size.width
            
            let heightOfImage = aspectRationImage * image.size.width
            let halfOriginalImage = image.size.height / 2
            let halfNewImage = heightOfImage / 2
            let offsetImageY = halfOriginalImage - halfNewImage
            rect.origin.y = offsetImageY
            rect.size.height = heightOfImage
        }
        
        //Crop image with aspectRation to screen. If it not make then result cropped image will scaled
        let resultImage = image.fixOrientation().croppedImage(rect)
        
        return resultImage

    }
    

    /// Cancel all requests to mathpix server if exist
    func cancelAllRequests() {
        for task in self.tasks {
            task.value.cancel()
        }
        self.tasks.removeAll()
    }
    
    /// Cancel request with corresponding id
    func cancelRequest(_ id: UUID) {
        if let task = tasks.removeValue(forKey: id) {
            task.cancel()
        }
    }
    
    
    /// Send image to mathpix server to recognize and then handle response data.
    @discardableResult func sendToServer(image:UIImage, appId: String?, appKey: String?, outputFormats formats: [MathpixFormat]?, complitionHandler: MathpixClient.RecognitionCallback?) -> UUID {
        
        guard let appId = appId, let appKey = appKey else {
            fatalError("Set api keys before request")
        }
        
        let URL = Foundation.URL(string: Constants.requestURL)!
        var request = URLRequest(url: URL)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        let base64String = imageData!.base64EncodedString(options: .init(rawValue: 0))
        // add app id and api key to headers
        let headers = [
            "content-type": "application/json",
            "app_id": appId,
            "app_key": appKey
        ]

        // convert formats to json dictionary
        var formatsJson : [String : Any] = [:]
        formats?.forEach{
            formatsJson[$0.json.key] = $0.json.value
        }
        var parameters = [
            "url": Constants.bodyStart + base64String,
            "formats": formatsJson,
            "ocr": Constants.math
            ] as [String : Any]
        
        // serialize json dictionary to Data
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        
        let session = URLSession(configuration: self.currentSessionConfiguration())
        // create uniq task key to save reference of task
        let taskId = UUID()
        
        if MathpixClient.debug {
            parameters.updateValue("...", forKey: "url")
            NSLog("Send request: %@", request.debugDescription)
            NSLog("parameters: %@", parameters)
        }
        let dataTask = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            // remove task from dictionary
            self?.tasks.removeValue(forKey: taskId)
            var currentError : Error?
            var result: RecognitionResult?
            // at the end call completion with error or result on the main thread
            defer {
                DispatchQueue.main.async(execute: {
                    if MathpixClient.debug {
                        if let error = currentError {
                            NSLog("Error request: %@", error.localizedDescription)
                        } else if let result = result?.parsed {
                            NSLog("Success request: %@", result)
                        }
                    }
                    complitionHandler?(currentError, result)
                    MathpixClient.completion?(currentError, result)
                })
            }
            
            // check for network error
            guard error == nil else {
                currentError = NetworkError(error: error! as NSError)
                return
            }
            // check for unpredictable error. This event must not be in regular process
            guard let data = data else {
                currentError = NSError(domain: "localhost", code: -1, userInfo: [NSLocalizedDescriptionKey : "Unpredictable error, contact with support"])
                return
            }
            
            // If error nil and we have response data then check for recognition errors
            do {
                result = try RecognitionResult(data: data)
            } catch {
                // If recognition error then send it to user
                currentError = error
            }
        })
        // save task in dictionary of all tasks to keep reference for cancel if needed
        self.tasks[taskId] = dataTask
        
        dataTask.resume()
        return taskId
    }
    
    
    
    
}
