//
//  SpriteViewController.m
//  SpriteKitActionDemo
//
//  Created by kay_sprint on 13-6-18.
//  Copyright (c) 2013年 cn.edu.scnu. All rights reserved.
//

#import "SpriteViewController.h"
#import "ActionScene.h"
#import "MyScene.h"
@import AVFoundation;

@interface SpriteViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation SpriteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *)self.view;
    [spriteView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    spriteView.showsFPS = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    //    ActionScene *action = [[ActionScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    MyScene *action = [[MyScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene:action];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
}

@end
