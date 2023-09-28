//
//  CameraSessionController.swift
//  MathPix
//
//  Created by Michael Lee on 3/25/16.
//  Copyright © 2016 MathPix. All rights reserved.
//

import Foundation
import UIKit

/**
 * This class is the top-level of the app UI, and
 * is responsible for handling navigation between the camera and result views.
 */
open class MathCaptureViewController: UIViewController
{
    /// Callback called after onBack method invoked.
    public var backButtonCallback : MathpixClient.BackButtonCallback?
    
    /// Callback called after recognition process completed.
    public var completionCallback : MathpixClient.RecognitionCallback?
    
    /// Formats that the mathpix server should represent in response.
    public var outputFormats : [MathpixFormat]?
    
    /// UI/UX properties to MathCaptureViewController.
    public var properties : MathCaptureProperties!
    
    /// Animation recognition delegate
    public weak var delegate: MathCaptureViewControllerRecognitionAnimationDelegate?
    
    /// Callback called when crop area selected
    public var regionSelectedCallback: (()->())?
    
    /// Callback called when crop area start dragging
    public var regionDraggingBeganCallback: (()->())?
    
    /// Callback called when crop area dragging
    public var regionDraggingCallback: ((_ bottomCenter : CGPoint)->())?
    
    fileprivate var cropOverlay : CropControlOverlay!
    fileprivate var cameraView = MPCameraSessionView(forAutoLayout: ())
    fileprivate var dimmingView : UIView?
    
    fileprivate let tapActionView = UIView(forAutoLayout: ())
    
    fileprivate var flashButton : UIButton = MPCameraFlashButton(forAutoLayout: ())
    fileprivate var shutterButton = UIButton(forAutoLayout: ())
    fileprivate var backButton = UIButton(forAutoLayout: ())
    
    fileprivate var infoTopConstraint: NSLayoutConstraint!
    
    fileprivate var cropInfoLabel = UILabel(forAutoLayout: ())
    
    fileprivate var animator: RecognitionAnimator!
    
    fileprivate var currentRequestId : UUID?

    override open var shouldAutorotate : Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        setupProperties()
        setupCamera()
        
        
        switch properties.captureType {
        case .button:
            setupShutterButton()
        case .gesture:
            setupLabels()
            setupGestures()
        }
        
        for button in properties.requiredButtons {
            switch button {
            case .back:
                setupBackButton()
            case .flash:
                setupFlashButton()
            }
        }
        
        setupOverlay()
        setupOverlayCallbacks()
        setupDimmingView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cropOverlay.resetView()
    }
    
    // MARK:  -  SETUP METHODS
    
    // Setup overlay view with crop area
    fileprivate func setupOverlay(){
        cropOverlay = CropControlOverlay(color: properties.cropColor)
        view.addSubview(cropOverlay)
        cropOverlay.autoPinEdgesToSuperviewEdges(with: properties.cropAreaInsets)
        cropOverlay.isResultViewActive = true
        
        animator = properties.animatorType.init()
    }
    
    // Setup callbacks to crop area events
    fileprivate func setupOverlayCallbacks() {
        cropOverlay.draggingCallback = { [unowned self] bottomCenter in
            let convertedPoint = self.view.convert(bottomCenter, from: self.cropOverlay)
            self.infoTopConstraint?.constant = convertedPoint.y + 20
            self.regionDraggingCallback?(convertedPoint)
        }
        cropOverlay.draggingBeganCallback = { [unowned self] in
            self.regionDraggingBeganCallback?()
        }
        cropOverlay.regionSelectedCallback = { [unowned self] in
            self.regionSelectedCallback?()
        }
    }

    
    // Setup help info label
    fileprivate func setupLabels() {
        cropInfoLabel.text = NSLocalizedString("Tap info label text", comment: "")
        cropInfoLabel.textColor = UIColor.white
        cropInfoLabel.font = UIFont.systemFont(ofSize: 20)
        cropInfoLabel.adjustsFontSizeToFitWidth = true
        cropInfoLabel.minimumScaleFactor = 0.6
        cropInfoLabel.numberOfLines = 1
        cropInfoLabel.textAlignment = .center
        
        view.addSubview(cropInfoLabel)
        cropInfoLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        cropInfoLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        infoTopConstraint = cropInfoLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
    }
    
    // Setup tap gesture to capture image
    fileprivate func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MathCaptureViewController.onCapture))
        tapActionView.addGestureRecognizer(tapGesture)
        tapActionView.backgroundColor = UIColor.clear
        view.addSubview(tapActionView)
        tapActionView.autoPinEdgesToSuperviewEdges()
    }
    
    
    // Setup camera view
    fileprivate func setupCamera() {
        self.view.addSubview(cameraView)
        self.cameraView.autoPinEdgesToSuperviewEdges()
        self.cameraView.delegate = self
        self.cameraView.hideCameraToogleButton()
        DispatchQueue.main.async {
            self.cameraView.hideFlashButton()
        }
    }
    
    
    // Setup flash button
    fileprivate func setupFlashButton() {
        if let flashIcon = properties.flashIcon {
            flashButton = UIButton(forAutoLayout: ())
            flashButton.setImage(flashIcon, for: .normal)
            flashButton.contentVerticalAlignment = .fill
            flashButton.contentHorizontalAlignment = .fill
        } else {
            let color = self.view.tintColor
            flashButton.layer.borderWidth = 1.5
            flashButton.layer.borderColor = color!.cgColor
            flashButton.layer.cornerRadius = properties.smallButtonSize.height / 2.0
            flashButton.layer.masksToBounds = true
        }
        flashButton.addTarget(self, action: #selector(MathCaptureViewController.onFlash), for: .touchUpInside)
        view.addSubview(flashButton)
        flashButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        flashButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        flashButton.autoSetDimensions(to: properties.smallButtonSize)
    }
    
    // Setup shutter button
    fileprivate func setupShutterButton() {
        shutterButton.setImage(properties.shutterIcon, for: .normal)
        shutterButton.contentVerticalAlignment = .fill
        shutterButton.contentHorizontalAlignment = .fill
        shutterButton.addTarget(self, action: #selector(MathCaptureViewController.onCapture), for: .touchUpInside)
        view.addSubview(shutterButton)
        shutterButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        shutterButton.autoAlignAxis(toSuperviewAxis: .vertical)
        shutterButton.autoSetDimensions(to: properties.bigButtonSize)
    }

    // Setup back button
    fileprivate func setupBackButton() {
        backButton.setImage(properties.backIcon, for: .normal)
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.addTarget(self, action: #selector(MathCaptureViewController.onBack), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        backButton.autoSetDimensions(to: properties.smallButtonSize)
    }
    
    /**
     *  This method called before viewDidLoad. Override it to set custom properties value. Do not call super.
     */
    open func setupProperties() {
        properties =  properties ?? MathCaptureProperties()
    }
    
    /**
     *  Set status bar style. Override if need change it.
     */
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
     *  This method set dimming view, which used when recognition process is active. Override this method to set yuor own dimming view. You can control it behavior via MathCaptureViewControllerRecognitionAnimationDelegate methods
     */
    open func setupDimmingView() {
        dimmingView = UIView(forAutoLayout: ())
        dimmingView?.backgroundColor = UIColor.clear
        dimmingView?.isHidden = true
        view.insertSubview(dimmingView!, belowSubview: cropOverlay)
        
        self.dimmingView?.autoPinEdge(.leading, to: .leading, of: view)
        self.dimmingView?.autoPinEdge(.trailing, to: .trailing, of: view)
        self.dimmingView?.autoPinEdge(.top, to: .top, of: view)
        self.dimmingView?.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
        
        let cancelButton = UIButton()
        cancelButton.setImage(properties.cancelIcon, for: .normal)
        cancelButton.contentVerticalAlignment = .fill
        cancelButton.contentHorizontalAlignment = .fill
        cancelButton.addTarget(self, action: #selector(MathCaptureViewController.onCancel), for: .touchUpInside)
        
        dimmingView?.addSubview(cancelButton)
        cancelButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        cancelButton.autoAlignAxis(toSuperviewAxis: .vertical)
        cancelButton.autoSetDimensions(to: properties.smallButtonSize)
    }

    
    // MARK: - Actions

    /// Turn on torch on camera.
    @objc public func onFlash() {
        self.cameraView.onTapFlashButton()
    }
    
    /// This method capture image when invoked.
    @objc public func onCapture() {
        changeControlsState(isEnabled: false)
        self.cropOverlay.flashCrop()
        self.cameraView.onTapShutterButton()
        self.animate(shutterButton)
        
        // Test in simulator
//        self.captureOnSimulator()
    }
    
    /// Cancel recognition process
    @objc public func onCancel() {
        changeControlsState(isEnabled: true)
        if let id = currentRequestId {
            MathpixClient.cancelRequest(id)
        }
    }
    
    /// Dismiss current controller
    @objc public func onBack() {
        backButtonCallback?()
        self.dismiss(animated: true)
    }
    
    /// Display error under crop area. This method is async. Error will be presented eventually.
    public func onDisplayErrorEventually(_ error: Error) {
        cropOverlay.displayErrorEventually(error)
    }
    
    
    // MARK: - Overriding methods
    
    /**
     *  This method called after recognition process is finished.
     *  - Parameter error: Error object if recognition failed.
     *  - Parameter result: RecognitionResult object if recognition succesed.
     */
    open func didRecieve(error: Error?, result: RecognitionResult?) {
        
    }
    
    /**
     *  This method change state of controls to enabled or disabled when capture/recognize process happens. You can ovveride this method to change your own controls state.
     *  - Parameter isEnabled: Bool value indicate what state of controlls need to be set.
     */
    open func controlStateChanged(isEnabled: Bool) {
        
    }
    
    
    
    // Helpers
    
    
    fileprivate func captureOnSimulator() {
        #if arch(i386) || arch(x86_64)
            self.didCapture(MathpixClient.getImageFromResourceBundle(name: "equation")!)
        #endif
    }
    
    fileprivate func changeControlsState(isEnabled: Bool) {
        flashButton.isEnabled = isEnabled
        shutterButton.isEnabled = isEnabled
        backButton.isEnabled = isEnabled
        tapActionView.gestureRecognizers?.forEach{ $0.isEnabled = isEnabled }
        cropOverlay.cropControl.isUserInteractionEnabled = isEnabled
        controlStateChanged(isEnabled: isEnabled)
    }
    
    

    // MARK: - Animations
    
    fileprivate let animationScaleTransformMultiplier : CGFloat = 1.8
    fileprivate let animationDuration = 0.27
    
    func animate(_ button: UIButton) {
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                button.transform = CGAffineTransform(scaleX: self.animationScaleTransformMultiplier, y: self.animationScaleTransformMultiplier)
            }, completion: nil)
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                button.transform = CGAffineTransform.identity
            }, completion: nil)
            
        }, completion: nil)
    }

    
    func startAnimateRecognition() {
        // Notify delegate
        self.delegate?.willStartAnimateRecognition?()
        // Show dimming view
        dimmingView?.alpha = 0.0
        dimmingView?.isHidden = false
        dimmingView?.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        // begin recognition animation
        self.cropOverlay.addSubview(animator.view)
        animator.view.autoCenterInSuperview()
        self.animator.beginAnimation()
        UIView.animate(withDuration: 0.4, animations: {
            self.dimmingView?.alpha = 1.0
            // Hide other controls
            self.cropInfoLabel.isHidden = true
            self.flashButton.isHidden = true
            self.shutterButton.isHidden = true
            self.backButton.isHidden = true
        }) { (finished) in
            // Notify delegate
            self.delegate?.didStartAnimateRecognition?()
        }
    }
    
    func stopAnimateRecognition(completionBlock: (() -> ())? = nil) {
        // Notify delegate
        self.delegate?.willEndAnimateRecognition?()
        // finish recognition animation
        self.animator.finishAnimation()
        self.animator.view.removeFromSuperview()
        UIView.animate(withDuration: 0.4, animations: {
            // Hide dimming view
            self.dimmingView?.alpha = 0.0
        }) { (finished) in
            self.dimmingView?.isHidden = true
            // Return other controls
            self.cropInfoLabel.isHidden = false
            self.flashButton.isHidden = false
            self.shutterButton.isHidden = false
            self.backButton.isHidden = false
            completionBlock?()
            // Clear crop area
            self.cropOverlay.clearResultView(animated: true)
            // Notify delegate
            self.delegate?.didEndAnimateRecognition?()
        }
    }

}


extension MathCaptureViewController: MPCameraSessionDelegate {
    open func didFailCaptureWithError(_ error: Error!) {
        changeControlsState(isEnabled: true)
        
        completionCallback?(error, nil)
        MathpixClient.completion?(error, nil)
        self.didRecieve(error: error, result: nil)
        
        var handled = false
        if let error = error, self.properties.errorHandling == true  {
            handled = true
            self.handle(error)
        }
        // Exit if completion not nil and error not handled internal
        if self.completionCallback != nil && !handled {
            self.dismiss(animated: true)
        }
    }
    
    open func didCapture(_ image: UIImage!) {
        if let resultImage = RecognitionService.cropImage(image, bounds: cameraView.bounds) {
            let croppedImage = cropOverlay.cropImageAndUpdateDisplay(resultImage, superview: cameraView)
            self.startAnimateRecognition()
            self.currentRequestId = MathpixClient.recognize(image: croppedImage, outputFormats: outputFormats, completion: { [weak self] (error, result) in
                self?.currentRequestId = nil
                self?.stopAnimateRecognition()
                self?.changeControlsState(isEnabled: true)
                // we don't need exit if user cancel request, catch request canceled error
                if let error = error as? NetworkError, error == .requestCanceled {
                    return
                }
                
                self?.completionCallback?(error, result)
                MathpixClient.completion?(error, result)
                self?.didRecieve(error: error, result: result)
                
                var handled = false
                if let error = error, self?.properties.errorHandling == true  {
                    handled = true
                    self?.handle(error)
                }
                // Exit if completion not nil and error not handled internal
                if self?.completionCallback != nil && !handled {
                    self?.dismiss(animated: true)
                }
            })
            
        }
    }
}





















