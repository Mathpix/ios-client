//
//  LaunchCameraButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 2/18/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPLaunchCameraButton.h"
#import "MPCameraStyleKitClass.h"

@interface MPLaunchCameraButton ()

@property BOOL isPressed;

@end

@implementation MPLaunchCameraButton

- (void)drawRect:(CGRect)rect
{
    [MPCameraStyleKitClass drawLaunchCameraWithFrame:self.bounds pressed:self.isPressed];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPressed = YES;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPressed = NO;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

@end
