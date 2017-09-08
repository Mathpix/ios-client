//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

///Protocol Definition
@protocol MPCameraSessionDelegate <NSObject>

@optional - (void)didCaptureImage:(UIImage *)image;
@optional - (void)didCaptureImageWithData:(NSData *)imageData;
@optional - (void)didFailCaptureWithError:(NSError*)error;

@end

@interface MPCameraSessionView : UIView

//Delegate Property
@property (nonatomic, weak) id <MPCameraSessionDelegate> delegate;

//API Functions
- (void)setTopBarColor:(UIColor *)topBarColor;
- (void)hideFlashButton;
- (void)hideCameraToogleButton;
- (void)hideDismissButton;
- (void)takeImage;
- (void)refocus;

- (void)onTapFlashButton;
- (void)onTapShutterButton;

@end
