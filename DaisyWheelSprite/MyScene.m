//
//  MyScene.m
//  DaisyWheelSprite
//
//  Created by Nidal Ilyas on 7/17/14.
//  Copyright (c) 2014 touchopia. All rights reserved.
//

#import "MyScene.h"
#import "Constants.h"
@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        rotateNow = FALSE;
        touchOnWheel = FALSE;
        self.userInteractionEnabled = YES;
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
    
    SKAction* soundAction = [SKAction playSoundFileNamed:kTapSoundFile waitForCompletion:NO];
    [self runAction:soundAction];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            CGFloat distance = SDistanceBetweenPoints(location,wheel.position);
            
            startPoint = location;
            startPoint2 = location;
            lastPoint = location;
            lastAngle = 0;
            
            if(distance < wheel.size.width/2*wheel.xScale)
                touchOnWheel = YES;
  
        }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        lastPoint = location;
        float alpha = 0.0f;
        if (touchOnWheel && !rotateNow) {
            CGFloat point1 = SDistanceBetweenPoints([wheel position], lastPoint);
            CGFloat point2 = SDistanceBetweenPoints([wheel position], startPoint2);
            alpha = atan2f(point2, point1);
            lastAngle = alpha;
            wheel.zRotation = alpha- M_PI_2 ;

            startPoint2 = location;
            
            NSString *nodeName = [NSString stringWithFormat:@"%d",(kTextTip+currentTip)];
            [self enumerateChildNodesWithName:nodeName usingBlock:^(SKNode *node, BOOL *stop) {
                [node setHidden:true];
            }];
        }
        
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

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

@end
