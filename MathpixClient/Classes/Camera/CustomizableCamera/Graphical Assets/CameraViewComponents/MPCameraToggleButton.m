//
//  CameraToggleButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPCameraToggleButton.h"
#import "MPCameraStyleKitClass.h"

@implementation MPCameraToggleButton

- (void)drawRect:(CGRect)rect {
    [MPCameraStyleKitClass drawCameraToggleWithFrame:self.bounds];
}

@end
