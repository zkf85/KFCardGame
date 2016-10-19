//
//  ViewController.m
//  KFCardGame
//
//  Created by Kefeng Zhu on 17/10/2016.
//  Copyright © 2016 Kefeng Zhu. All rights reserved.
//

#import "ViewController.h"
#import "KFCardMatchingGame.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchingDescription;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeChange;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic, strong) KFCardMatchingGame *game;

@property (nonatomic) NSInteger gameMode; // mode=0 2-match; mode=1, 3-match; mode=2, 3-match hard

@end

@implementation ViewController

//setter of

// getter of gameMode
- (NSInteger)gameMode {
    if(!_gameMode) _gameMode = 0;
    return _gameMode;
}


// segmented control to change the game mode
- (IBAction)playModeChange:(UISegmentedControl *)sender {
    self.gameMode = sender.selectedSegmentIndex;
}

// set the titles of the segmentedControl


// init for game in game's getter
- (KFCardMatchingGame *)game {
    if(!_game) _game = [[KFCardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
    
}


// create a deck (for initializging a game
- (KFDeck *)createDeck {
    return [[KFDeck alloc] init];
}


- (IBAction)tapCardButton:(UIButton *)sender {
    self.modeChange.enabled = NO;
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    self.matchingDescription.text = [self.game chooseCardAtIndex:cardIndex atMode:self.gameMode];
    [self updateUI];
    
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        KFCard *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}

-(NSString *)titleForCard:(KFCard *)card {
    if (card.matched || card.chosen) {
        return card.content;
    } else return @"";
}

-(UIImage *)backgroundImageForCard:(KFCard *)card {
    if (card.matched || card.chosen) {
        return [UIImage imageNamed:@"cardfront"];
    } else {
        return [UIImage imageNamed:@"cardback"];
    }
}

- (IBAction)resetGame {
    self.modeChange.enabled = YES;
    self.game = [[KFCardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    self.matchingDescription.text = @"KF's Card Matching Game.\n Please Choose Game Mode.";
    [self updateUI];
}


// about autorotate
- (BOOL)shouldAutorotate {
    return NO;
}


-(void)viewDidLoad {
    // initialize the label string
    self.matchingDescription.text = @"KF's Card Matching Game.\n Please Choose Game Mode.";
}
@end
