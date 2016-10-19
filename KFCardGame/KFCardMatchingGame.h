//
//  KFCardMatchingGame.h
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFDeck.h"
@interface KFCardMatchingGame : NSObject
@property (nonatomic) NSUInteger score;

-(instancetype)initWithCardCount:(NSInteger) count usingDeck:(KFDeck *)deck;

// this is the core of the game
-(NSString *)chooseCardAtIndex:(NSInteger)index atMode:(NSInteger)mode;

// return the chosen card at index
-(KFCard *)cardAtIndex:(NSInteger)index;

@end
