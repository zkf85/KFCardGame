//
//  KFCard.m
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import "KFCard.h"

@implementation KFCard
@synthesize suit = _suit;

// define how to match this card to other card or cards
// need further work here!
-(int)match:(NSArray *)otherCards {
    int score = 0;
    // according to my score list 10/17/2016, calculated based on probabilities for each case
    //
    if (otherCards.count == 1) {
        KFCard *otherCard = otherCards[0];
        if ([self.suit isEqualToString:otherCard.suit]) {
            score += 5; // P1
        } else if (self.rank == otherCard.rank) {
            score += 20; // P2
        }
    }
    return score;
}

- (int)matchTwo:(NSArray *)otherCards {
    int score = 0;
    if (otherCards.count == 2) {
        int scoreSum = [self match:@[otherCards[0]]] + [self match:@[otherCards[1]]] + [otherCards[0] match:@[otherCards[1]]];
        switch (scoreSum) {
            case 5:
                score += 2;
                break;
            case 15:
                score += 20;
                break;
            case 20:
                score += 6;
                break;
            case 25:
                score += 24;
                break;
            case 60:
                score += 500;
                break;
            default:
                break;
        }
    }
    return score;
}

+ (NSArray *)validSuits {
    return @[@"♠️",@"♣️",@"♦️",@"♥️"];
}

+ (NSArray *)rankString {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}


+ (NSInteger)maxRank {
    // here is actually set as 13
    return [self rankString].count - 1;
    
}

// re-configure the  getter and setter of propert "suit"
- (NSString *)suit {
    return _suit ? _suit : @"?";
}
- (void)setSuit:(NSString *)suit {
    if([[KFCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


//re-configure the getter of content@end
- (NSString *)content {
    return [self.suit stringByAppendingString:[KFCard rankString][self.rank]];
}

@end
