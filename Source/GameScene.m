//
//  GameScene.m
//  ruoxiaow
//
//  Created by longma on 3/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

{
    __weak CCNode* _levelNode;
    __weak CCPhysicsNode* _physicsNode;
    __weak CCNode* _playerNode;
    __weak CCNode* _backgroundNode;
}

-(void) didLoadFromCCB
{
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadLevelNamed:nil];
    NSLog(@"_levelNode = %@", _levelNode);
}

-(void) loadLevelNamed:(NSString*)levelCCB
{
    // get the current level's player in the scene by searching for it recursively
    _playerNode = [self getChildByName:@"player" recursively:YES];
    NSAssert1(_playerNode, @"player node not found in level: %@", levelCCB);
}

-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    // move the player to the touch location smoothly
    [_playerNode stopActionByTag:1]; // Stop an action by tag to avoid having multiple move
                                     // actions running simultaneously
    CGPoint pos = [touch locationInNode:_levelNode]; // this allow the player to move about the
                                                     // full extents of the _levelNode (4000x500 points)
    CCAction* move = [CCActionMoveTo actionWithDuration:1.2 position:pos];
    move.tag = 1;
    [_playerNode runAction:move];
}


-(void) exitButtonPressed
{
    NSLog(@"Get me outa here!");
    
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) update:(CCTime)delta
{
    // update scroll node position to player node, with offset to center player in the view
    [self scrollToTarget:_playerNode];
}

-(void) scrollToTarget:(CCNode*)target
{
    // assign the size of the view to viewSize,
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    // the center point of the view is calculated and assigned to viewCenter
    CGPoint viewCenter = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    // keeps the target node centered in the view
    CGPoint viewPos = ccpSub(target.positionInPoints, viewCenter);
    // clamp the viewPos to the level’s size using the MIN and MAX macros
    CGSize levelSize = _levelNode.contentSizeInPoints;
    viewPos.x = MAX(0.0, MIN(viewPos.x, levelSize.width - viewSize.width));
    viewPos.y = MAX(0.0, MIN(viewPos.y, levelSize.height - viewSize.height));
    _levelNode.positionInPoints = ccpNeg(viewPos);
}

@end
