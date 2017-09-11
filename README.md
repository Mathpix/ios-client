# MathpixClient

[![Language](https://img.shields.io/badge/swift-3.0-orange.svg)](https://developer.apple.com/swift)



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Installation

#### CocoaPods

MathpixClient is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MathpixClient"
```



## Usage

#### Set api keys:

```swift
import MathpixClient

MathpixClient.setApiKeys(appId: "demo_app", appKey: "demo_key")
```

#### Recognize images:

You can use MathpixClient to recognize images:

```swift
MathpixClient.recognize(image: UIImage(named: "equation")!, outputFormats: [FormatLatex.simplified]) { (error, result) in
    print(result ?? error)
}
```

#### Launch camera:

You can launch camera controller to capture and recognize images:

```swift
        MathpixClient.launchCamera(source: self,
                                   outputFormats: [FormatLatex.simplified],
                                   backButtonCallback: {
                                        print("back button pressed") },
                                   completion: { (error, result) in
                                        print("complete") })
```

#### Launch camera with custom UI/UX properties:

You can fine tune camera controller using `MathCaptureProperties` instance:

```swift
let properties = MathCaptureProperties(captureType: .gesture,
                                               requiredButtons: [.flash, .back],
                                               cropColor: UIColor.green,
                                               errorHandling: true)
        
        MathpixClient.launchCamera(source: self,
                                   outputFormats: [FormatLatex.simplified],
                                   withProperties: properties,
                                   backButtonCallback: {
                                        print("back button pressed") },
                                   completion: { (error, result) in
                                        print("complete") })

```

#### Subclass `MathCaptureViewController`

If you need more control, you can subclass `MathCaptureViewController`.

```swift
class CustomCameraViewController: MathCaptureViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add your UI elements here
        
    }


}

```



## API



### MathpixFormat

Protocol represents additional field "formats" in request body. Requested as parameter `outputFormats` array. You can set several values:

#### FormatLatex

The latex field, if present, is one of “raw” (result is the unmodified OCR output), “defaultValue” (result is OCR output with extraneous spaces removed), or “simplified” (result has spaces removed, operator shortcuts, and is split into lists where appropriate):

```swift
    public enum FormatLatex {
        case raw, defaultValue, simplified
    }
```

#### FormatMathml
The mathml field, if present and set to on, indicates the server should add a mathml field to the JSON result that is a string containing the MathML markup for the recognized math. In the case of an incompatible result, the server will instead add a mathml_error:

```swift
    public enum FormatMathml {
        case on
    }
```

#### FormatWolfram

The wolfram field, if present and set to on, indicates the server should add a wolfram field to the JSON result that is a string compatible with the Wolfram Alpha engine. In the case of an incompatible result, the server will instead add a wolfram_error field:

```swift
    public enum FormatWolfram {
        case on
    }
```




### MathCaptureProperties

The struct to incapsulate `MathCaptureViewController` properties. You can customize some UI/UX values:

The color of crop overlay bounds
```swift
    let cropColor: UIColor
```

The icon of shutter button
```swift
    let shutterIcon : UIImage?
```

The icon of flash button
```swift
    let flashIcon : UIImage?
```

The icon of back button
```swift
    let backIcon : UIImage?
```

The icon of cancel request button
```swift
    let cancelIcon : UIImage?
```

The type of `RecognitionAnimator`. Used to provide animation for recognition process
```swift
    let animatorType : RecognitionAnimator.Type
```

The type of UI capture action
```swift
    let captureType: CaptureType
    
    public enum CaptureType {
        /// Tap gesture is used to capture image.
        case gesture
        /// Shutter button is used to capture image.
        case button
    }
```

The buttons which will be presented in instantiated `MathCaptureViewController`
```swift
    let requiredButtons: [MathCaptureButton]
    
     public enum MathCaptureButton {
        /// Back button
        case back
        /// Flash button
        case flash
    }
```

The size of `shutter` button
```swift
    let bigButtonSize: CGSize
```

The size of buttons
```swift
    let smallButtonSize: CGSize
```

The crop area insets
```swift
    let cropAreaInsets: UIEdgeInsets
```

If enabled then errors will be handled by capture controller
```swift
    let errorHandling: Bool
```



### MathCaptureViewController

You can subclass it to get more control. See example app.

## Error handling

For simple internal error handling add `errorHandling: true` parameter to **MathCaptureProperties**.
Errors that you can get in callbacks represents by two main types:

#### NetworkError

Error type will be thrown if network failed

```swift
public enum NetworkError: Error {

    /// Unknown or not supported error.
    case unknown
    
    /// Not connected to the internet.
    case notConnectedToInternet
    
    /// International data roaming turned off.
    case internationalRoamingOff
    
    /// Cannot reach the server.
    case notReachedServer
    
    /// Connection is lost.
    case connectionLost
    
    /// Incorrect data returned from the server.
    case incorrectDataReturned
    
    /// Request canceled.
    case requestCanceled
}

```

#### RecognitionError

Error type will be thrown if recognition failed

```swift
public enum RecognitionError: Error {

    /// Failed parse JSON, incorrect data returned
    case failedParseJSON
    
    /// Server can't recognize image as math
    case notMath(description: String)
    
    /// Invalid credentials, set correct api keys
    case invalidCredentials
}

```

### Example Error Handling:

```swift
        MathpixClient.launchCamera(source: self,
                                   outputFormats: [FormatLatex.simplified],
                                   completion:
                                        { (error, result) in
                                            if let error = error as? NetworkError {
                                                handleNetworkError(error)
                                            } else if let error = error as? RecognitionError {
                                                handleRecognitionError(error)
                                            } else if let error = error {
                                                handleOtherError(error)
                                            }
                                            ...
        })

```

## Localization

To set labels or error messages add `Localizable.strings` file to your project if you haven't it. Then change values:

```
// Errors
"Error credintials title" = "Error";
"Error credintials messages" = "Invalid credentials";
"Error capture title" = "Error capture";
"Error capture message" = "Capture image error";
"Error timeout title" = "Timeout error";
"Error timeout message" = "Send image timeout";
"Error no connection tittle" = "Network error";
"Error no connection message" = "No internet connection";
"Error parse title" = "Error parse";
"Error parse message" = "Error parse json";

// Tap info label
"Tap info label text" = "Tap anywhere to take a picture";
```


## License

MathpixClient is available under the MIT license. See the LICENSE file for more info.
