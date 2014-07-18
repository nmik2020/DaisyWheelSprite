//
//  MyScene.m
//  DaisyWheelSprite
//
//  Created by Nidal Ilyas on 7/17/14.
//  Copyright (c) 2014 touchopia. All rights reserved.
//

#import "MyScene.h"
#import "Constants.h"

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180
#define kCGPointEpsilon FLT_EPSILON

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        rotateNow = FALSE;
        touchOnWheel = FALSE;
        self.userInteractionEnabled = YES;
        glClearColor(1.0f , 1.0f, 1.0f, 1);

        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"i_main_screen_bg.png"];
        background.position =  CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        wheel = [SKSpriteNode spriteNodeWithImageNamed:@"i_wheel_tips.png"];
        wheel.position = CGPointMake(kiPhoneWheelX,kiPhoneWheelY);
        [self addChild:wheel];
        
        SKSpriteNode *flower = [SKSpriteNode spriteNodeWithImageNamed:@"i_wheel_cover.png"];
        flower.position = CGPointMake(kiPhoneFlowerX,kiPhoneFlowerY);
        [self addChild:flower];
        
        for (int i = 1; i <= 8; i++) {
            [self createSpriteTip:i];
        }
    }
    
    oldAngle = wheel.zRotation;
    currentTip = 1;
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
        for (UITouch *touch in touches)
        {
            CGPoint location = [touch locationInNode:self];
            
            float distance = rwLength(subtractPoint(location,wheel.position));
            
            startPoint = location;
            startPoint2 = location;
            lastPoint = location;
            lastAngle = 0;
            
            if(distance < wheel.size.width/2*wheel.xScale)
                touchOnWheel = YES;
            else
                touchOnWheel = NO;
            NSLog(touchOnWheel ? @"Yes" : @"No");

        }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];

        lastPoint = location;
        float alpha = 0.0f;
        NSLog(touchOnWheel ? @"Yes" : @"No");

        if (touchOnWheel && !rotateNow)
        {
            CGPoint point1 = subtractPoint(location,[wheel position]);
            CGPoint point2 = subtractPoint(startPoint2,[wheel position]);
        
            alpha = angleBetweenPoints(point1, point2);
            lastAngle = alpha;
            [self rotateToAngle:alpha] ;

            startPoint2 = location;

        }
        
    }
}


//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//
//
//}

-(void)createSpriteTip:(int)number
{
    SKSpriteNode *textTip = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"i_tip-%d.png",number]];
    textTip.position = CGPointMake(kiPhoneTipX,kiPhoneTipY);
    [textTip setHidden:TRUE];
    textTip.name = [NSString stringWithFormat:@"%d",number];
    [self addChild:textTip];
}

CGFloat SDistanceBetweenPoints(CGPoint first, CGPoint second) {
    return hypotf(second.x - first.x, second.y - first.y);
}

CGPoint subtractPoint(CGPoint first, CGPoint second) {
    return CGPointMake(first.x - second.x, first.y - second.y);
}

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    first = rwNormalize(first);
    second = rwNormalize(second);
    CGFloat a = ((first.x * second.y) - (first.y*second.x));
    CGFloat b = ((first.x * second.x) + (first.y*second.y));
    float angle = atan2f(a, b);

    if( fabs(angle) < kCGPointEpsilon ) return 0.f;
	return angle;
}
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

- (float) normalAngleFromAngle: (float)angle
{
	while (angle > 360)
		angle -= 360;
	
	while (angle < 0)
		angle += 360;
	
    return angle;
}

- (void) rotateToAngle: (float) angle
{
	wheel.zRotation += CC_RADIANS_TO_DEGREES(angle);
	wheel.zRotation = [self normalAngleFromAngle:wheel.zRotation];
    NSLog(@"Angle of Rotation : %f",wheel.zRotation);
}
@end
