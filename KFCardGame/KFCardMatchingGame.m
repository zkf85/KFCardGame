//
//  KFCardMatchingGame.m
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import "KFCardMatchingGame.h"

@interface KFCardMatchingGame()
@property (nonatomic, strong) NSMutableArray *cardsInGame;
//@property (nonatomic, strong) NSMutableArray *otherTwoCards;
@end

@implementation KFCardMatchingGame
// getter os the cardsInGame
- (NSMutableArray *)cardsInGame {
    if(!_cardsInGame) _cardsInGame = [[NSMutableArray alloc] init];
    return _cardsInGame;
}
//- (NSMutableArray *)otherTwoCards {
//    if (!_otherTwoCards) _otherTwoCards = [[NSMutableArray alloc] init];
//    return _otherTwoCards;
//}

// a new init: choose a fix number of cards from deck to be stored in cardsInGame
- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(KFDeck *)deck {
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            KFCard *card = [deck drawRandomCard];
            if (card) {
                [self.cardsInGame addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (instancetype)init {
    return nil;
}


- (KFCard *)cardAtIndex:(NSInteger)index {
    return (index < self.cardsInGame.count) ? self.cardsInGame[index] : nil;
}


// Core Logic of this game
static const int COST_TO_CHOOSE = 1;
static const int MATCH_BONUS = 2;
static const int MISMATCH_PENALTY = 2;

- (NSString *)chooseCardAtIndex:(NSInteger)index atMode:(NSInteger)mode {
    KFCard *card = [self cardAtIndex:index];
    NSString * description = @"";
    if(!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            // 2-card-match mode
            if (mode == 0) {
                description = card.content;
                
                for (KFCard *otherCard in self.cardsInGame) {
                    // only choose the card with the tag "chosen" and which is NOT matched yet to do the match!
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            card.matched = YES;
                            otherCard.matched = YES;
                            description = [NSString stringWithFormat:@"Matched %@ and %@.\nAward %d points.",card.content,otherCard.content,matchScore*MATCH_BONUS];
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                            description = [NSString stringWithFormat:@"%@ and %@ don't match!\n%d point penalty!",card.content,otherCard.content,MISMATCH_PENALTY];
                        }
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
            
            // 3-card-match mode
            else if (mode == 1) {
                
                int otherCardCount = 0;
                int ab = 0;
                int ac = 0;
                int bc = 0;
                
                description = card.content;
                KFCard *card_1, *card_2;
                
                for (KFCard *otherCard in self.cardsInGame) {
                    if (otherCard.chosen) {
                        otherCardCount += 1;
                        if (otherCardCount == 1) card_1 = otherCard;
                        if (otherCardCount == 2) card_2 = otherCard;
                    }
                }
                
                if (otherCardCount == 2) {
                    //NSLog(@"otherTwoCards has %ld cards!", (unsigned long)[otherTwoCards count]);
                    
                    ab = [card match:@[card_1]];
                    ac = [card match:@[card_2]];
                    bc = [card_1 match:@[card_2]];
                    
                    if ((ab+ac+bc) != 0) {
                        // 3 of 3 same suit
                        if ((ab+ac+bc)==15) {
                            self.score += 15*MATCH_BONUS;
                            description = [NSString stringWithFormat:@"Matched %@, %@ and %@ with the same suit.\nAward %d points.",card.content,card_1.content,card_2.content,15*MATCH_BONUS];
                        }
                        // 3 of 3 same rank
                        if ((ab+ac+bc)==60) {
                            self.score += 500*MATCH_BONUS;
                            description = [NSString stringWithFormat:@"Matched %@, %@ and %@ with the same suit.\nAward %d points.",card.content,card_1.content,card_2.content,500*MATCH_BONUS];
                        }
                        // 2 of 3 same suit
                        if ((ab+ac+bc)==5) {
                            if (ab==5) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit.\nAward %d points.",card.content,card_1.content,2*MATCH_BONUS];
                            if (ac==5) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit.\nAward %d points.",card.content,card_2.content,2*MATCH_BONUS];
                            if (bc==5) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit.\nAward %d points.",card_1.content,card_2.content,2*MATCH_BONUS];
                        }
                        // 2 of 3 same rank
                        if ((ab+ac+bc)==20) {
                            if (ab==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same rank.\nAward %d points.",card.content,card_1.content,6*MATCH_BONUS];
                            if (ac==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same rank.\nAward %d points.",card.content,card_2.content,6*MATCH_BONUS];
                            if (bc==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same rank.\nAward %d points.",card_1.content,card_2.content,6*MATCH_BONUS];
                        }
                        // 2 of 3 same suit, 2 of 3 same rank
                        if ((ab+bc+ac)==25) {
                            if (ab==5 && ac==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank.\nAward %d points.",card.content,card_1.content,card.content,card_2.content,24*MATCH_BONUS];
                            if (ab==5 && bc==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank.\nAward %d points.",card.content,card_1.content,card_1.content,card_2.content,24*MATCH_BONUS];
                            if (ac==5 && ab==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank.\nAward %d points.",card.content,card_2.content,card.content,card_1.content,24*MATCH_BONUS];
                            if (ac==5 && bc==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank.\nAward %d points.",card.content,card_2.content,card_1.content,card_2.content,24*MATCH_BONUS];
                            if (bc==5 && ab==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank.\nAward %d points.",card_1.content,card_2.content,card.content,card.content,24*MATCH_BONUS];
                            if (bc==5 && ac==20) description = [NSString stringWithFormat:@"Matched %@ and %@ with the same suit, %@ and %@ with the same rank. \nAward %d points.",card_1.content,card_2.content,card.content,card_2.content,24*MATCH_BONUS];
                        }
                        
                        card.matched = YES;
                        card.chosen = NO;
                        card_1.matched = YES;
                        card_2.matched = YES;
                        card_1.chosen = NO;
                        card_2.chosen = NO;
                    }
                    
                    else {
                        self.score -= MISMATCH_PENALTY;
                        card_1.chosen = NO;
                        card_2.chosen = NO;
                        description = [NSString stringWithFormat:@"No match in %@, %@ and %@!\n%d point penalty!",card.content,card_1.content,card_2.content,MISMATCH_PENALTY];
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
                if (otherCardCount == 2 && (ab+bc+ac) ) card.chosen = NO;
            }
        }
    }
    return description;
} // designed 10/17/2016 by KF

@end
