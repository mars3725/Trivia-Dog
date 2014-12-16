///
//  MMOptionsScene.m
//  Trivia Dog
//
//  Created by Matthew Mohandiss on 6/9/14.
//  Copyright (c) 2014 Matthew Mohandiss. All rights reserved.
//

#import "MMOptionsScene.h"
#import "MMMenuScene.h"
#import "MMMainScene.h"
@implementation MMOptionsScene

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

-(void)setup
{
    self.backgroundColor = [SKColor colorWithRed:0 green:1 blue:1 alpha:1];
    //Difficulty can be 1=Hard 4=Normal 7=Easy
    SKLabelNode* backButton = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    backButton.text = @"Back";
    backButton.fontSize = 30;
    backButton.name=@"Back";
    backButton.position = CGPointMake(CGRectGetMidX(self.frame)+230, CGRectGetMidY(self.frame)+120);
    backButton.fontColor = fontColor;
    
    SKLabelNode* makerLabel= [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    makerLabel.text = @"A Game By Matthew Mohandiss";
    makerLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    makerLabel.fontColor = fontColor;
    
    SKLabelNode* difficultyLabel = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    difficultyLabel.text = @"Nothing To See Here";
    difficultyLabel.fontSize = 50;
    difficultyLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    difficultyLabel.fontColor = fontColor;
    
    [self addChild:difficultyLabel];
    [self addChild:makerLabel];
    [self addChild:backButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKLabelNode *backButton = (SKLabelNode*)[self childNodeWithName:@"Back"];
    
    if ([backButton containsPoint:location]) {
        SKScene *nextScene = [[MMMenuScene alloc] initWithSize:self.size];
        SKTransition *slideleft = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1];
        [self.view presentScene:nextScene transition:slideleft];
    }
}

@end
