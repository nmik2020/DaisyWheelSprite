//
//  MyScene.h
//  DaisyWheelSprite
//

//  Copyright (c) 2014 touchopia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene {
    SKSpriteNode	*wheel;
	CGPoint		startPoint;
	CGPoint		startPoint2;
	CGPoint		lastPoint;
	float		lastAngle;
	float		oldAngle;
	bool touchOnWheel;
	bool rotateNow;
	NSInteger	currentTip;
}

@end
