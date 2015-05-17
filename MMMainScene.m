//
//  MMMyScene.m
//  SheepJumper
//
//  Created by Matthew Mohandiss on 5/29/14.
//  Copyright (c) 2014 Matthew Mohandiss. All rights reserved.
//

#import "MMMainScene.h"
#import "MMMenuScene.h"

@implementation MMMainScene

static const uint32_t monsterCategory = 0x1 << 0;
static const uint32_t dogCategory = 0x1 << 1;

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        fontColor = [SKColor grayColor];
        self.physicsWorld.gravity =CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        [self setup];
        [self newQuestion];
        [self performSelector:@selector(newmonster) withObject:nil afterDelay:2.5];
    }
    return self;
}

-(void) setup
{
    self.name = @"Game_Scene";
    
    //A few methods
    [self setupPlist];
    [self actions];
    NSLog(@"Root Class: %@",self.class);
    
    //varriable setup
    lives = 3;
    isJumping = NO;
    isDamaged = NO;
    jumpCredits = 3;
    selected = nil;
    
    //labels setup
    SKLabelNode *life = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    life.name = @"life";
    life.fontSize = 20;
    life.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+120);
    life.fontColor = fontColor;
    
    SKLabelNode *jumps = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    jumps.name = @"jumps";
    jumps.fontSize = 20;
    jumps.position = CGPointMake(CGRectGetMidX(self.frame)+150, CGRectGetMidY(self.frame)+120);
    jumps.fontColor = fontColor;
    
    SKLabelNode *scoretxt = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    scoretxt.name = @"score";
    scoretxt.fontSize = 20;
    scoretxt.position = CGPointMake(CGRectGetMidX(self.frame)-25, CGRectGetMidY(self.frame)+120);
    scoretxt.fontColor = fontColor;
    
    Question = [NORLabelNode labelNodeWithFontNamed:@"Monaco"];
    Question.lineSpacing = 1;
    Question.fontSize = 25;
    Question.fontColor = fontColor;
    Question.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+85);
    
    A = [NORLabelNode labelNodeWithFontNamed:@"Monaco"];
    A.name =@"A";
    A.lineSpacing = 1;
    A.fontSize = 20;
    A.fontColor = fontColor;
    A.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)+30);
    
    B = [NORLabelNode labelNodeWithFontNamed:@"Monaco"];
    B.name =@"B";
    B.lineSpacing = 1;
    B.fontSize = 20;
    B.fontColor = fontColor;
    B.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-20);
    
    C = [NORLabelNode labelNodeWithFontNamed:@"Monaco"];
    C.name =@"C";
    C.lineSpacing = 1;
    C.fontSize = 20;
    C.fontColor = fontColor;
    C.position = CGPointMake(CGRectGetMidX(self.frame)+100, CGRectGetMidY(self.frame)+30);
    
    D = [NORLabelNode labelNodeWithFontNamed:@"Monaco"];
    D.name =@"D";
    D.lineSpacing = 1;
    D.fontSize = 20;
    D.fontColor = fontColor;
    D.position = CGPointMake(CGRectGetMidX(self.frame)+100, CGRectGetMidY(self.frame)-20);
    
    //Hit Boxes
    CGRect rect = CGRectMake(-70, -25, 140, 50);
    Abox = [[SKShapeNode alloc] init];
    Abox.position = A.position;
    Abox.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    Abox.strokeColor = [SKColor clearColor];
    
    Bbox = [[SKShapeNode alloc] init];
    Bbox.position = B.position;
    Bbox.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    Bbox.strokeColor = [SKColor clearColor];
    
    Cbox = [[SKShapeNode alloc] init];
    Cbox.position = C.position;
    Cbox.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    Cbox.strokeColor = [SKColor clearColor];
    
    Dbox = [[SKShapeNode alloc] init];
    Dbox.position = D.position;
    Dbox.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    Dbox.strokeColor = [SKColor clearColor];
    
    
    //background Image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size =  self.size;
    background.name =@"background";
    
    //dog
    dog = [SKSpriteNode spriteNodeWithImageNamed:@"dog_1"];
    dog.Scale = 1;
    dog.position = CGPointMake(CGRectGetMidX(self.frame)+160, CGRectGetMidY(self.frame)-110);
    
    dog.physicsBody =
    [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(dog.size.width - 10, dog.size.height - 10)];
    dog.physicsBody.usesPreciseCollisionDetection = YES;
    dog.physicsBody.categoryBitMask = dogCategory;
    dog.physicsBody.collisionBitMask = 0;
    dog.physicsBody.contactTestBitMask = monsterCategory;
    [dog runAction:[SKAction repeatActionForever:doganimation]];
    
    //add to scene
    [self addChild:background];
    [self addChild:life];
    [self addChild:jumps];
    [self addChild:scoretxt];
    [self addChild:dog];
    [self addChild:Question];
    [self addChild:A];
    [self addChild:B];
    [self addChild:C];
    [self addChild:D];
    [self addChild:Abox];
    [self addChild:Bbox];
    [self addChild:Cbox];
    [self addChild:Dbox];
}

-(void)setupPlist
{
    //find plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    QuestionsArray = [NSMutableArray arrayWithArray:[plistData objectForKey:@"Questions"]];
}

-(void)newmonster
{
    //monster
    monster = [SKSpriteNode spriteNodeWithImageNamed:@"Monster"];
    monster.position = CGPointMake(CGRectGetMidX(self.frame)-300, CGRectGetMidY(self.frame)-120);
    monster.Scale = 1.5;
    monster.name = @"monster";
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -23, -14.5);
    CGPathAddLineToPoint(path, NULL, 16, -18);
    CGPathAddLineToPoint(path, NULL, 21, 17.5);
    CGPathAddLineToPoint(path, NULL, 3, 9);
    CGPathCloseSubpath(path);
    
    monster.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    monster.physicsBody.usesPreciseCollisionDetection = YES;
    monster.physicsBody.categoryBitMask = monsterCategory;
    monster.physicsBody.contactTestBitMask = dogCategory;
    monster.physicsBody.collisionBitMask = 0;
    
    //add to scene
    [self addChild:monster];
    //float frequency;
    float base = (1-0.05);
    float randomNum = 10*(powf(base, (score/5)));
    
    NSLog(@"New monster appears in %f seconds",randomNum);
    
    [self performSelector:@selector(newmonster) withObject:nil afterDelay:randomNum];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if ([Abox containsPoint:location])
    {
        NSLog(@"Touched choice A");
        selected = @"A";
        if ([Answer  isEqual: @"A"])
        {
            A.fontColor = [SKColor greenColor];
        }
        else
        {
            A.fontColor = [SKColor redColor];
        }
    }
    else if ([Bbox containsPoint:location])
    {
        NSLog(@"Touched choice B");
        selected = @"B";
        if ([Answer  isEqual: @"B"])
        {
            B.fontColor = [SKColor greenColor];
        }
        else
        {
            B.fontColor = [SKColor redColor];
        }
    }
    else if ([Cbox containsPoint:location])
    {
        NSLog(@"Touched choice C");
        selected = @"C";
        if ([Answer  isEqual: @"C"])
        {
            C.fontColor = [SKColor greenColor];
        }
        else
        {
            C.fontColor = [SKColor redColor];
        }
    }
    else if ([Dbox containsPoint:location])
    {
        NSLog(@"Touched choice D");
        selected = @"D";
        if ([Answer  isEqual: @"D"])
        {
            D.fontColor = [SKColor greenColor];
        }
        else
        {
            D.fontColor = [SKColor redColor];
        }
    }
    
    //Character Jump
    if (selected == nil && jumpCredits >= 1) {
        NSLog(@"NULL");
        if (jumpCredits >= 1) {
        isJumping = YES;
        [dog runAction:jumpMovement];
        [dog runAction:jumpAnimation];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    A.fontColor = fontColor;
    B.fontColor = fontColor;
    C.fontColor = fontColor;
    D.fontColor = fontColor;

    if ([selected isEqualToString:Answer]) {
        selected = nil;
        if ([Answer  isEqual: @"A"]) {
            jumpCredits++;
            [self newQuestion];
        }
        else if ([Answer  isEqual: @"B"]) {
            jumpCredits++;
            [self newQuestion];
        }
        else if ([Answer  isEqual: @"C"]) {
            jumpCredits++;
            [self newQuestion];
        }
        else if ([Answer  isEqual: @"D"]) {
            jumpCredits++;
            [self newQuestion];
        }
        
        }
    else if (selected != nil) {
            score--;
        selected = nil;
        }
}

-(void)actions
{
    SKTextureAtlas *dogatlas = [SKTextureAtlas atlasNamed:@"dog"];
    SKTexture *f1 = [dogatlas textureNamed:@"dog_1.png"];
    SKTexture *f2 = [dogatlas textureNamed:@"dog_2.png"];
    SKTexture *f3 = [dogatlas textureNamed:@"dog_3.png"];
    SKTexture *f4 = [dogatlas textureNamed:@"dog_4.png"];
    SKTexture *f5 = [dogatlas textureNamed:@"dog_5.png"];
    SKTexture *f6 = [dogatlas textureNamed:@"dog_6.png"];
    NSArray *doganim = @[f1,f2,f3,f4,f5,f6];
    doganimation = [SKAction animateWithTextures:doganim timePerFrame:0.1];
    
    SKAction* moveUp = [SKAction moveByX:0 y:90 duration:.6];
    SKAction* moveDown = [SKAction moveByX:0 y:-90 duration:0.4];
    SKAction* done = [SKAction performSelector:@selector(jumpDone) onTarget:self];
    jumpMovement = [SKAction sequence:@[moveUp, moveDown, done]];
    
    SKTexture *j2 = [SKTexture textureWithImageNamed:@"dog_1"];
    NSArray *jumpTextures = @[j2];
    jumpAnimation = [SKAction animateWithTextures:jumpTextures timePerFrame:1];
    
    NSLog(@"Actions are Loaded");
}

-(void)jumpDone
{
    isJumping = NO;
    jumpCredits--;
    if(isDamaged)
    {
    isDamaged = NO;
    }
    else
    {
        score = score+10;
    }
    
    if ( lives == 0)
    {
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:1.0];
    }
    
    NSLog(@"jump finished");
}

-(void)doDamage:(SKSpriteNode*)character
{
    isDamaged = YES;
    if (lives > 0) {
        lives--;
    }
    else
    {
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:1];
    }
    SKAction* push = [SKAction moveByX:+3 y:0 duration:0.2];
    [character runAction:push];
    SKAction *yelp = [SKAction playSoundFileNamed:@"yelp.mp3" waitForCompletion:NO];
    [character runAction:yelp];
    SKAction *pulseRed = [SKAction sequence:@[
                [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.5],
                [SKAction colorizeWithColorBlendFactor:0.0 duration:0.5],]];
    
    [character runAction:pulseRed];
}

-(void)gameOver
{
    
    NSLog(@"GAME OVER");
    SKScene *nextScene = [[MMMenuScene alloc] initWithSize:self.size];
    SKTransition *fade = [SKTransition pushWithDirection:SKTransitionDirectionDown duration:1];
    [self.view presentScene:nextScene transition:fade];
}

-(void)newQuestion
{
    currentQuestion = arc4random_uniform((int)[QuestionsArray count]);
    NSLog(@"New Question with id: %i",currentQuestion);
    QuestionsDict = [NSDictionary dictionaryWithDictionary:
                     [QuestionsArray objectAtIndex:currentQuestion]];
    Answer = [QuestionsDict objectForKey:@"Answer"];
    
    Question.text = [QuestionsDict objectForKey:@"Question"];
    A.text = [QuestionsDict objectForKey:@"A"];
    B.text = [QuestionsDict objectForKey:@"B"];
    C.text = [QuestionsDict objectForKey:@"C"];
    D.text = [QuestionsDict objectForKey:@"D"];
    
    if (Question.text.length > 30)
    {
        NSLog(@"Attempting to break 'Question'");
        [self breakString:Question];
    }
    
    if (A.text.length > 15)
    {
        NSLog(@"Attempting to break 'A'");
        [self breakString:A];
    }
    if (B.text.length > 15)
    {
        NSLog(@"Attempting to break 'B'");
        [self breakString:B];
    }
    if (C.text.length > 15)
    {
        NSLog(@"Attempting to break 'C'");
        [self breakString:C];
    }
    if (D.text.length > 15)
    {
        NSLog(@"Attempting to break 'D'");
        [self breakString:D];
    }
    
}

-(void)update:(CFTimeInterval)currentTime
{
    
    SKLabelNode *life = (SKLabelNode*)[self childNodeWithName:@"life"];
    life.text = [NSString stringWithFormat:@"Lives: % i", lives];
    
    SKLabelNode *jumps = (SKLabelNode*)[self childNodeWithName:@"jumps"];
    jumps.text = [NSString stringWithFormat:@"Jumps: % i", jumpCredits];
    
    SKLabelNode *scoretxt = (SKLabelNode*)[self childNodeWithName:@"score"];
    scoretxt.text = [NSString stringWithFormat:@"Score: % i", score];
    
    [self enumerateChildNodesWithName:@"monster" usingBlock:^(SKNode *node, BOOL *stop) {
        if(monster.position.x >600){
            [self removeFromParent];
        }else{
            node.position = CGPointMake(node.position.x + 4, node.position.y);
        }}];
    
    if (jumpCredits < 2)
    {
        jumps.fontColor = [SKColor redColor];
    }
    else
    {
        jumps.fontColor = fontColor;
    }
    
    if (lives < 2)
    {
        life.fontColor = [SKColor redColor];
    }
    else
    {
        life.fontColor = fontColor;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"intersection");
    [self doDamage:dog];
}

-(id)breakString:(NORLabelNode*)string
{
    NSString *newString = [NSMutableString stringWithString:string.text];
    NSMutableArray *words = (NSMutableArray*)[newString componentsSeparatedByString:@" "];
    NSString *linebreak =@"\n";
    [words insertObject:linebreak atIndex:[words count]/2];
    string.text = [words componentsJoinedByString:@" "];
    return string;
}

@end