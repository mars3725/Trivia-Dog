//
//  MMViewController.m
//  SheepJumper
//
//  Created by Matthew Mohandiss on 5/29/14.
//  Copyright (c) 2014 Matthew Mohandiss. All rights reserved.
//

#import "MMViewController.h"
#import "MMMenuScene.h"

@import AVFoundation;
@interface MMViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation MMViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Audio Initilization
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Platform" withExtension:@"aif"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self playMusic]; //---------------------------------Music
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsDrawCount = NO;
    skView.showsPhysics = NO;
    
    // Create and configure the scene.
    SKScene * scene = [MMMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)playMusic
{
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}

@end
