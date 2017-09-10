//
//  MathpixClient.swift
//  Pods
//
//  Created by Дмитрий Буканович on 29.08.17.
//
//

import Foundation


/**
 *  The central class of the MathpixClient framework.
 *  @note This class can only be used from the main thread.
 */
public class MathpixClient {
    
    /**
     *  The type of block invoked when recognition related events complete.
     *  - Parameter error: The error which occurred, if any.
     *  - Parameter result: The result or recognition.
     */
    public typealias RecognitionCallback =  (_ error: Error?, _ result: RecognitionResult?) -> Void
    
    /**
     *  The type of block invoked when user press `back` button on `MathCaptureViewController` instance.
     */
    public typealias BackButtonCallback = () -> Void
    
    // Mathpix AppID value
    private static var appId: String?
    // Mathpix AppKey value
    private static var appKey: String?
    // Service which sends image to server for recognize
    private static var recognitionService = RecognitionService() 
    /// Completion block when recognition process is complete
    public static var completion : RecognitionCallback?
    /// Enable/Disable debug messages 
    public static var debug : Bool = false
    
    /**
     *  Set Mathpix api keys.
     *  - Parameter appId: app id key 
     *  - Parameter appKey: app key
     */
    public class func setApiKeys(appId: String, appKey: String) {
        MathpixClient.appId = appId
        MathpixClient.appKey = appKey
    }
    
    /**
     Recognize image by mathpix server.
     
     - Parameter image: image to send on server for recognize.
     - Parameter formats: formats that the mathpix server should represent in response.
     - Parameter completion: completion block will be called on the main thread after recognition process is finished. If nill then completion static property of MathpixClient is called.
     - Returns:  Request id that can be used to cancel.
     */
    @discardableResult public class func recognize(image: UIImage, outputFormats formats: [MathpixFormat]?, completion: RecognitionCallback?) -> UUID {
        let id = MathpixClient.recognitionService.sendToServer(
            image: image,
            appId: MathpixClient.appId,
            appKey: MathpixClient.appKey,
            outputFormats: formats,
            complitionHandler: completion)
        return id
    }
    
    /**
     *  Cancel all requests on mathpix server.
     *  If any request exists, it will be canceled. `RecognitionCallback` block will be called for each canceled request with NetworkError.requestCanceled error.
     */
    public class func cancelAllRequests() {
        MathpixClient.recognitionService.cancelAllRequests()
    }
    
    /**
     *  Cancel request with corresponding id on mathpix server.
     *  If any request exists, it will be canceled. `RecognitionCallback` block will be called for each canceled request with NetworkError.requestCanceled error.
     *  - Parameter id: id of request that need be canceled.
     */
    public class func cancelRequest(_ id: UUID) {
        MathpixClient.recognitionService.cancelRequest(id)
    }
    
    /**
     *  Present MathCaptureViewController with properties.
     *  - Parameter source: image to send on server for recognize.
     *  - Parameter formats: formats that the mathpix server should represent in response.
     *  - Parameter properties: UI/UX properties to camera controller.
     *  - Parameter backButtonCallback: completion block will be called after user press back button.
     *  - Parameter completion: completion block will be called on the main thread after recognition process is finished.
     */
    public class func launchCamera(source: UIViewController, outputFormats formats: [MathpixFormat]?, withProperties properties: MathCaptureProperties? = nil, backButtonCallback: BackButtonCallback? = nil, completion: @escaping RecognitionCallback) {
        let captureVC = MathCaptureViewController()
        captureVC.backButtonCallback = backButtonCallback
        captureVC.completionCallback = completion
        captureVC.outputFormats = formats
        captureVC.properties = properties ?? MathCaptureProperties()
        source.present(captureVC, animated: true, completion: nil)
    }
}










