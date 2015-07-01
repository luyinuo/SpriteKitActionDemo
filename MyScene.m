//
//  MyScene.m
//  SpriteKitActionDemo
//
//  Created by Kevin on 15/7/1.
//  Copyright (c) 2015年 cn.edu.scnu. All rights reserved.
//

#import "MyScene.h"
@interface MyScene()
@property (nonatomic, strong) NSMutableArray *textures;
@end
@implementation MyScene

- (NSMutableArray *)textures
{
    if (!_textures) {
        _textures = [NSMutableArray array];
    }
    return _textures;
}
- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createContents];
        self.contentCreated = YES;
    }
}

- (void)createContents{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"dog"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"cat"];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"monkey"];
    SKTexture *texture4 = [SKTexture textureWithImageNamed:@"panda"];
    [self.textures addObjectsFromArray:[NSArray arrayWithObjects:texture1,texture2,texture3,texture4, nil]];
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithTexture:texture1];
//    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"dog"];
    player.name = @"player";
    player.size = CGSizeMake(50, 50);
    player.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    
    SKAction *change = [SKAction runBlock:^{
        int range = arc4random() % 4;
        [SKAction setTexture:self.textures[range]];
    }];
    SKAction *walkAnimation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4] timePerFrame:2];
    SKAction *repeat = [SKAction repeatActionForever:walkAnimation];
    [player runAction:repeat];
    [self addChild:player];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *player = [self childNodeWithName:@"player"];
    if (player) {
        SKAction *moveBy = [SKAction moveBy:<#(CGVector)#> duration:<#(NSTimeInterval)#>]
    }
}


@end
