//
//  MyScene.m
//  SpriteKitActionDemo
//
//  Created by Kevin on 15/7/1.
//  Copyright (c) 2015年 cn.edu.scnu. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"

static const uint32_t playerCategory         =  0x1 << 0;
static const uint32_t playerCategory1        =  0x1 << 1;
static const uint32_t monsterCategory        =  0x1 << 2;
static const uint32_t bombCategory           =  0x1 << 3;

@interface MyScene()<SKPhysicsContactDelegate>
@property (nonatomic, strong) NSMutableArray *textures;
@property (nonatomic, strong) NSMutableArray *foods;
@property (nonatomic, strong) SKSpriteNode *player;
@property (nonatomic, strong) SKSpriteNode *player2;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int monstersDestroyed;
@property (nonatomic) BOOL touchedHero;
@property (nonatomic) BOOL touchedHero1;
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
        SKTexture *texture5 = [SKTexture textureWithImageNamed:@"bomber"];
        [_foods addObjectsFromArray:[NSArray arrayWithObjects:texture1,texture2,texture3,texture4,texture5, nil]];
    }
    return _foods;
}
- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createContents];
        self.contentCreated = YES;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    }
}

- (void)createContents{
    //    self.backgroundColor = [SKColor clearColor];
    SKSpriteNode *backGround = [SKSpriteNode spriteNodeWithImageNamed:@"bg1"];
    backGround.size = self.frame.size;
    backGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height /2 );
    [self addChild:backGround];
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"cat_close_1"];
    
    _player = [SKSpriteNode spriteNodeWithTexture:texture2];
    _player.name = @"player";
    _player.size = CGSizeMake(130, 150);
    _player.position = CGPointMake(self.frame.size.width/4, 75);
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    _player.physicsBody.dynamic = YES;
    _player.physicsBody.categoryBitMask  = playerCategory;
    _player.physicsBody.contactTestBitMask = monsterCategory;
    _player.physicsBody.collisionBitMask = 0;
    
    _player2 = [SKSpriteNode spriteNodeWithTexture:texture2];
    _player2.name = @"player2";
    _player2.size = CGSizeMake(130, 150);
    _player2.position = CGPointMake(self.frame.size.width*3/4, 75);
    _player2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    _player2.physicsBody.dynamic = YES;
    _player2.physicsBody.categoryBitMask  = playerCategory1;
    _player2.physicsBody.contactTestBitMask = monsterCategory;
    _player2.physicsBody.collisionBitMask = 0;
    
    
    //    SKAction *walkAnimation = [SKAction animateWithTextures:@[texture2, texture3] timePerFrame:0.2];
    //    SKAction *repeat = [SKAction repeatActionForever:walkAnimation];
    //    [_player runAction:repeat];
    [self addChild:_player];
    //    [self addChild:_player2];
    
    SKCropNode *crop = [[SKCropNode alloc] init];
    crop.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithImageNamed:@"panda"];
    mask.size = CGSizeMake(300, 300);
    SKAction *up = [SKAction moveByX:0 y:100 duration:2];
    SKAction *down = [SKAction moveByX:0 y:-100 duration:2];
    SKAction *right = [SKAction moveByX:100 y:0 duration:2];
    SKAction *left = [SKAction moveByX:-100 y:0 duration:2];
    [mask runAction:[SKAction repeatActionForever:[SKAction sequence:@[up, down, right, left]]]];
    crop.maskNode = mask;
    [crop addChild:_player2];
    [self addChild:crop];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"player"]) {
        if (YES) NSLog(@"touch in hero");
        _touchedHero = YES;
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"cat"];
        SKAction *action = [SKAction setTexture:texture3];
        [_player runAction:action];
    }else if ([node.name isEqualToString:@"player2"]){
        _touchedHero1 = YES;
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"cat"];
        SKAction *action = [SKAction setTexture:texture3];
        [_player2 runAction:action];
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"player"]) {
        _touchedHero = NO;
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"cat_close_1"];
        SKAction *action = [SKAction setTexture:texture3];
        [_player runAction:action];
    }else if ([node.name isEqualToString:@"player2"]){
        _touchedHero1 = NO;
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"cat_close_1"];
        SKAction *action = [SKAction setTexture:texture3];
        [_player2 runAction:action];
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
    int random = arc4random() % 5;
    SKTexture *texture = self.foods[random];
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithTexture:texture];
    monster.size = CGSizeMake(50, 50);
    monster.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10]; // 1
    monster.physicsBody.dynamic = YES; // 2
    if (random < 4) {
        monster.physicsBody.categoryBitMask = monsterCategory; // 3
    }else{
        monster.physicsBody.categoryBitMask = bombCategory; // 3
    }
    
    
    monster.physicsBody.contactTestBitMask = playerCategory|playerCategory1; // 4
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
    
    CGFloat moveToX = random % 2 ==0 ?self.size.width/4:self.size.width *3/4;
    // Create the actions
    SKAction * actionMove1 = [SKAction moveTo:CGPointMake(moveToX, 100) duration:actualDuration];
    SKAction * actionMove2 = [SKAction moveTo:CGPointMake(moveToX, -monster.size.height/2) duration:actualDuration * 100/self.size.height];
    //沿指定的角度旋转
    SKAction *rotateBy = [SKAction rotateByAngle:1.4 duration:0.5];
    //旋转到指定的角度
    SKAction *rotateTo = [SKAction rotateToAngle:0 duration:0.5];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    SKAction *group = [SKAction group:@[rotateBy,rotateTo,actionMove1]];
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:2];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    
    
    if (random < 4) {
        //        [monster runAction:[SKAction sequence:@[group,actionMove2,loseAction, actionMoveDone]]];
    }else{
        //        [monster runAction:[SKAction sequence:@[group,actionMove2, actionMoveDone]]];
    }
    
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    NSLog(@"Hit");
    //    [projectile removeFromParent];
    [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
    [monster removeFromParent];
    self.monstersDestroyed++;
    if (self.monstersDestroyed > 30) {
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (!_touchedHero1 && !_touchedHero) {
        return;
    }
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 ) {//第一个猫
        if (_touchedHero) {
            if ((secondBody.categoryBitMask & monsterCategory) != 0){
                [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
            }else if ((secondBody.categoryBitMask & bombCategory) != 0){
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:gameOverScene transition: reveal];
            }
            
        }
    }
    if ((firstBody.categoryBitMask & playerCategory1) != 0) {//第二只猫
        if (_touchedHero1 ) {
            if ((secondBody.categoryBitMask & monsterCategory) != 0){
                [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
            }else if ((secondBody.categoryBitMask & bombCategory) != 0){
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:gameOverScene transition: reveal];
            }
        }
    }
    
    // 2
    //    if (((firstBody.categoryBitMask & playerCategory) != 0 &&
    //        (secondBody.categoryBitMask & monsterCategory) != 0) ||
    //        ((firstBody.categoryBitMask & playerCategory1) != 0 &&
    //        (secondBody.categoryBitMask & monsterCategory) != 0 ))
    //    {
    //
    //        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    //    }else{
    //
    //        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    //        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
    //        [self.view presentScene:gameOverScene transition: reveal];
    //    }
}
@end
