//
//  MPCameraDismissButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPCameraDismissButton.h"
#import "MPCameraStyleKitClass.h"

@implementation MPCameraDismissButton

- (void)drawRect:(CGRect)rect {
    [MPCameraStyleKitClass drawCameraDismissWithFrame:self.bounds];
}

@end
