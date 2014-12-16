//
//  MMMenuScene.m
//  Trivia Dog
//
//  Created by Matthew Mohandiss on 6/9/14.
//  Copyright (c) 2014 Matthew Mohandiss. All rights reserved.
//

#import "MMMenuScene.h"
#import "MMMainScene.h"
#import "MMOptionsScene.h"

@implementation MMMenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        fontColor = [SKColor grayColor];
        [self setup];
    }
    return self;
}

-(void) setup
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background2"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size =  self.size;
    background.name =@"background";
    
    SKSpriteNode *Title = [SKSpriteNode spriteNodeWithImageNamed:@"Title"];
    Title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30);
    Title.name = @"title";
    Title.Scale = .3;
    
    Play = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    Play.text = @"Play";
    Play.position = CGPointMake(CGRectGetMidX(self.frame)-75, CGRectGetMidY(self.frame)-50);
    Play.fontColor = fontColor;
    
    Options = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    Options.text = @"Options";
    Options.position = CGPointMake(CGRectGetMidX(self.frame)+75, CGRectGetMidY(self.frame)-50);
    Options.fontColor = fontColor;
    
    [self addChild:background];
    [self addChild:Play];
    [self addChild:Options];
    [self addChild:Title];
}

-(void)actionSetup
{
    SKAction *enlarge = [SKAction customActionWithDuration:1 actionBlock:
                         ^(SKNode *node, CGFloat elapsedTime) {
                             node.Scale = 1.5;
                         }];
    SKAction *wait = [SKAction waitForDuration:.2];
    SKAction *shrink = [SKAction customActionWithDuration:1 actionBlock:
                         ^(SKNode *node, CGFloat elapsedTime) {
                             node.Scale = 1;
                         }];
    bulge = [SKAction sequence:@[enlarge,wait,shrink]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode *title = (SKSpriteNode*)[self childNodeWithName:@"title"];
    
    if ([Play containsPoint:location]) {
        SKScene *nextScene = [[MMMainScene alloc] initWithSize:self.size];
        SKTransition *slideup = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1];
        [self.view presentScene:nextScene transition:slideup];
    }
    else if ([Options containsPoint:location])
    {
        SKScene *nextScene = [[MMOptionsScene alloc] initWithSize:self.size];
        SKTransition *slideright = [SKTransition pushWithDirection:SKTransitionDirectionRight duration:1];
        [self.view presentScene:nextScene transition:slideright];
    }
    if ([title containsPoint:location] && touches.count != 0)
    {
        [title runAction:bulge];
    }
}

@end


