//
//  KFCard.h
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFCard : NSObject

@property (nonatomic, strong) NSString *content; // content include the suit and rank of the card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSInteger rank;

@property (nonatomic, getter=isMatched) BOOL matched;
@property (nonatomic, getter=isChosen) BOOL chosen;

- (int)match:(NSArray *)otherCards; // match this card with all the rest cards in the playing deck, in which there actually only one (or two) card is in the state of chosen and to be  matched. The return value is the matching score.
- (int)matchTwo:(NSArray *)otherCards; // 3-card-match game, to match another two cards


+ (NSArray *)validSuits; // valid suits
+ (NSArray *)rankString; // valid rankString A, 2, 3 .. 10 .. K
+ (NSInteger)maxRank;

@end
