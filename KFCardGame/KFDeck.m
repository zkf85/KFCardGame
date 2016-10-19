//
//  KFDeck.m
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import "KFDeck.h"

@implementation KFDeck

// the getter of 'cards'
- (NSMutableArray *)cards {
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


-(void)addCards:(KFCard *)card atTop:(BOOL)atTop {
    if(atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (void)addCards:(KFCard *)card {
    [self addCards:card atTop:NO];
}


- (KFCard *)drawRandomCard {
    KFCard *randomCard = nil;
    if(self.cards.count) {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
        
    return randomCard;
}



//redefine the init method for KFDeck
- (instancetype)init {
    self = [super init];
    if(self) {
        // build a 52 cards deck with double loop
        for (NSString *suit in [KFCard validSuits]) {
            for (NSInteger rank = 1; rank <= [KFCard maxRank]; rank++) {
                KFCard *card = [[KFCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCards:card];
            }
        }
    }
    return self;
}
@end
