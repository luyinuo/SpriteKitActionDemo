//
//  ActionScene.m
//  SpriteKitActionDemo
//
//  Created by kay_sprint on 13-6-18.
//  Copyright (c) 2013年 cn.edu.scnu. All rights reserved.
//

#import "ActionScene.h"

@implementation ActionScene

- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createContents];
        self.contentCreated = YES;
    }
}

- (void)createContents{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self shipNode]];
}

- (SKSpriteNode *)shipNode{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", document, @"ship.png"];
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship.png"];
    ship.name = @"shipNode";
    ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    return ship;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    SKNode *ship = [self childNodeWithName:@"shipNode"];
    if (ship) {
        //沿指定的x，y距离移动
        SKAction *moveByXY = [SKAction moveByX:50 y:50 duration:0.5];
        //移动到指定的点
        SKAction *moveTo = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) duration:0.5];
        //研指定的x距离移动
        SKAction *moveByX1 = [SKAction moveToX:CGRectGetMidX(self.frame) + 50 duration:0.5];
        SKAction *moveByX2 = [SKAction moveToX:CGRectGetMidX(self.frame) duration:0.5];
        //研指定的y距离移动
        SKAction *moveByY1 = [SKAction moveToY:CGRectGetMidY(self.frame) + 50 duration:0.5];
        SKAction *moveByY2 = [SKAction moveToY:CGRectGetMidY(self.frame) duration:0.5];

        //改变工作执行的速度，0可以认为是暂停，1是正常速度
        SKAction *speedBy = [SKAction speedBy:0 duration:0.5];
        SKAction *speedTo = [SKAction speedTo:1 duration:0.5];

        //沿指定的角度旋转
        SKAction *rotateBy = [SKAction rotateByAngle:1.4 duration:0.5];
        //旋转到指定的角度
        SKAction *rotateTo = [SKAction rotateToAngle:0 duration:0.5];

        //缩放，by是可逆的，to是不可逆的
        SKAction *scaleBy = [SKAction scaleBy:2 duration:1];
        SKAction *scaleTo = [SKAction scaleTo:1 duration:1];
        SKAction *scaleXYby = [SKAction scaleXBy:1 y:2 duration:1];
        SKAction *scaleXYto = [SKAction scaleXTo:2 y:2 duration:1];
        SKAction *scaleXto = [SKAction scaleXTo:1 duration:1];
        SKAction *scaleYto = [SKAction scaleYTo:1 duration:1];

        //淡入淡出
        SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];

        //改变Sprite的size
        SKAction *resieByWH = [SKAction resizeByWidth:64 height:32 duration:1];
        SKAction *resizeToW = [SKAction resizeToWidth:32 duration:1];
        SKAction *resizeToH = [SKAction resizeToHeight:30 duration:1];
        SKAction *resizeToWH = [SKAction resizeToWidth:40 height:32 duration:1];

        //改变Sprite的texture
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *document = [path objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", document, @"ship1.png"];
        SKTexture *ship1 = [SKTexture textureWithImageNamed:fileName];
        SKAction *setTexture = [SKAction setTexture:ship1];

        //等待2秒
        SKAction *wait = [SKAction waitForDuration:2];
        //移除ship
        SKAction *removeShip = [SKAction removeFromParent];

        SKAction *sequence = [SKAction sequence:@[moveByXY, moveTo, moveByX1, moveByX2, moveByY1, moveByY2, speedBy, speedTo, rotateBy, rotateTo, scaleBy, scaleTo, scaleXYby, scaleXYto, scaleXto, scaleYto, fadeOut, fadeIn, resieByWH, resizeToW, resizeToH, resizeToWH, setTexture, wait, removeShip]];
//        [ship runAction:sequence];
        
        [ship runAction:sequence completion:^{
            [self addChild:[self newYanweixia]];
        }];
        
//        [self addChild:[self newYanweixia]];
    }
}

- (SKSpriteNode *)newYanweixia{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSString *yan1 = [NSString stringWithFormat:@"%@/%@", document, @"walkR01.png"];
    NSString *yan2 = [NSString stringWithFormat:@"%@/%@", document, @"walkR02.png"];
    NSString *yan3 = [NSString stringWithFormat:@"%@/%@", document, @"walkR03.png"];
    NSString *yan4 = [NSString stringWithFormat:@"%@/%@", document, @"walkR04.png"];
    NSString *yan5 = [NSString stringWithFormat:@"%@/%@", document, @"walkR05.png"];

    /*
    NSString *altas = [NSString stringWithFormat:@"%@/%@", document, @"images.atlas"];
    SKTextureAtlas *walk = [SKTextureAtlas atlasNamed:altas];
    SKTexture *wr01 = [walk textureNamed:@"walkR01.png"];
    */

    SKTexture *walkR01 = [SKTexture textureWithImageNamed:yan1];
    SKTexture *walkR02 = [SKTexture textureWithImageNamed:yan2];
    SKTexture *walkR03 = [SKTexture textureWithImageNamed:yan3];
    SKTexture *walkR04 = [SKTexture textureWithImageNamed:yan4];
    SKTexture *walkR05 = [SKTexture textureWithImageNamed:yan5];

    SKAction *walkAnimation = [SKAction animateWithTextures:@[walkR01, walkR02, walkR03, walkR04, walkR05] timePerFrame:0.2];
    //SKAction *walk = [SKAction repeatAction:walkAnimation count:2];
    //SKAction *walk = [SKAction sequence:@[walkAnimation, walkAnimation]];
    SKAction *move = [SKAction moveByX:100 y:0 duration:1];
    SKAction *walkForward = [SKAction group:@[walkAnimation, move]];
    SKAction *positiveXscale = [SKAction scaleXTo:1 y:1 duration:0.1];
    SKAction *negativeXscale = [SKAction scaleXTo:-1 y:1 duration:0.1];
    SKAction *moveBack = [SKAction moveByX:-100 y:0 duration:1];
    SKAction *walkBack = [SKAction group:@[walkAnimation, moveBack]];
    SKAction *walkSequence = [SKAction sequence:@[positiveXscale, walkForward, negativeXscale, walkBack]];
    SKAction *repeatWalk = [SKAction repeatActionForever:walkSequence];
    
    SKSpriteNode *ywx = [SKSpriteNode spriteNodeWithTexture:walkR01];
    ywx.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [ywx runAction:repeatWalk];
    
    return ywx;
}

@end
