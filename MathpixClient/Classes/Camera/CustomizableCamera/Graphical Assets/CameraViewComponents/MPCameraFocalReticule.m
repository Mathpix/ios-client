//
//  CameraFocusIndicator.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/25/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPCameraFocalReticule.h"
#import "MPCameraStyleKitClass.h"

@implementation MPCameraFocalReticule

- (void)drawRect:(CGRect)rect {
    [MPCameraStyleKitClass drawCameraFocusWithFrame:self.bounds];
}

@end
