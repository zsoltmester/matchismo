//
//  ViewController.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"

// abstract
@interface CardMatchingGameViewController : UIViewController

extern NSString *const USER_DEFAULTS_HIGH_SCORES;
extern NSString *const HIGH_SCORES_CATEGORY_SCORE;
extern NSString *const HIGH_SCORES_CATEGORY_TIME;

+ (NSString *)gameName; // abstract
- (GameMode)gameMode; // abstract
- (Deck *)createDeck; // abstract
- (NSAttributedString *)titleForCard:(Card*)card; // abstract

@end

