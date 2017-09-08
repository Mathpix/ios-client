//
//  CameraFlashButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPCameraFlashButton.h"
#import "MPCameraStyleKitClass.h"

@implementation MPCameraFlashButton

- (void)drawRect:(CGRect)rect {
    [MPCameraStyleKitClass drawCameraFlashWithFrame:self.bounds];

}

@end
