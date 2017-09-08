//
//  CameraShutterButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "MPCameraShutterButton.h"
#import "MPCameraStyleKitClass.h"

@implementation MPCameraShutterButton

- (void)drawRect:(CGRect)rect {
	if (self.isBlue) {
		[MPCameraStyleKitClass drawCameraShutterWithFrame:self.bounds style:true];
	}
	else {
		[MPCameraStyleKitClass drawCameraShutterWithFrame:self.bounds style:false];
	}
}

@end
