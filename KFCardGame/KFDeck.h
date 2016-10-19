//
//  KFDeck.h
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFCard.h"

@interface KFDeck : NSObject

@property (nonatomic, strong) NSMutableArray *cards;

- (void)addCards:(KFCard *)card atTop:(BOOL)atTop; // add the card at top
- (void)addCards:(KFCard *)card; // append new card to the end

- (KFCard *)drawRandomCard;

@end
