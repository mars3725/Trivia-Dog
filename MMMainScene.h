//
//  MMMyScene.h
//  SheepJumper
//

//  Copyright (c) 2014 Matthew Mohandiss. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NORLabelNode.h"
#import <math.h>

@class MMViewController;

@interface MMMainScene : SKScene <SKPhysicsContactDelegate>
{
    SKColor *fontColor;
    
    SKAction *doganimation;
    SKAction *monsteranimation;
    SKSpriteNode *dog;
    SKSpriteNode *monster;
    SKAction *jumpMovement;
    SKAction *jumpAnimation;
    BOOL isJumping;
    BOOL isDamaged;
    BOOL hitCount;
    int lives;
    int jumpCredits;
    int score;
    
    NSDictionary* QuestionsDict;
    NSMutableArray* QuestionsArray;
    
    NORLabelNode *Question;
    NORLabelNode *A;
    NORLabelNode *B;
    NORLabelNode *C;
    NORLabelNode *D;
    SKShapeNode *Abox;
    SKShapeNode *Bbox;
    SKShapeNode *Cbox;
    SKShapeNode *Dbox;
    NSString *Answer;
    NSString * selected;
    
    int currentQuestion;
    SKAction *correct;
    SKAction *incorect;
}
@end