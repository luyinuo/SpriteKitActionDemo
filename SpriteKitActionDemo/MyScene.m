//
//  MyScene.m
//  SpriteKitActionDemo
//
//  Created by Kevin on 15/7/1.
//  Copyright (c) 2015年 cn.edu.scnu. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;

@interface MyScene()<SKPhysicsContactDelegate>
@property (nonatomic, strong) NSMutableArray *textures;
@property (nonatomic, strong) NSMutableArray *foods;
@property (nonatomic, strong) SKSpriteNode *player;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end
@implementation MyScene

- (NSMutableArray *)textures
{
    if (!_textures) {
        _textures = [NSMutableArray array];
    }
    return _textures;
}

- (NSMutableArray *)foods
{
    if (!_foods) {
        _foods = [NSMutableArray array];
        SKTexture *texture1 = [SKTexture textureWithImageNamed:@"banana"];
        SKTexture *texture2 = [SKTexture textureWithImageNamed:@"fish"];
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"bone"];
        SKTexture *texture4 = [SKTexture textureWithImageNamed:@"bambo"];
        [_foods addObjectsFromArray:[NSArray arrayWithObjects:texture1,texture2,texture3,texture4, nil]];
    }
    return _foods;
}
- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createContents];
        self.contentCreated = YES;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
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
    _player = [SKSpriteNode spriteNodeWithTexture:texture1];
//    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"dog"];
    _player.name = @"player";
    _player.size = CGSizeMake(100, 100);
    _player.position = CGPointMake(CGRectGetMidX(self.frame), 70);
    
    SKAction *change = [SKAction runBlock:^{
        int range = arc4random() % 4;
        [SKAction setTexture:self.textures[range]];
    }];
    SKAction *walkAnimation = [SKAction animateWithTextures:@[texture1, texture2, texture3, texture4] timePerFrame:2];
    SKAction *repeat = [SKAction repeatActionForever:walkAnimation];
    [_player runAction:repeat];
    [self addChild:_player];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *player = [self childNodeWithName:@"player"];
    if (player) {
        NSTimeInterval interval = 320 / 1;
        CGFloat ranglengt = fabs(player.position.x - location.x);
        location.x < _player.size.width /2 ?location.x = _player.size.width /2:1;
        location.x > self.frame.size.width - (_player.size.width /2)?location.x = self.frame.size.width - (_player.size.width /2):1;
        
        SKAction *moveBy = [SKAction moveToX:location.x duration:ranglengt/interval];
        [player runAction:moveBy];
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addFoods];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

- (void) addFoods
{
    // Create sprite
    int random = arc4random() % 4;
    SKTexture *texture = self.foods[random];
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithTexture:texture];
    monster.size = CGSizeMake(50, 50);
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = monsterCategory; // 3
    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5
    
    // Determine where to spawn the monster along the Y axis
    
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = CGPointMake(actualX, self.frame.size.height + monster.size.height/2);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), -monster.size.height/2) duration:actualDuration];
    //沿指定的角度旋转
    SKAction *rotateBy = [SKAction rotateByAngle:1.4 duration:0.5];
    //旋转到指定的角度
    SKAction *rotateTo = [SKAction rotateToAngle:0 duration:0.5];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[rotateBy,rotateTo,actionMove]];
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    [monster runAction:[SKAction sequence:@[group, actionMoveDone]]];
}
@end
