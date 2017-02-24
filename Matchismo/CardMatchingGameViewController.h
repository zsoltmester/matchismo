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

- (GameMode)gameMode; // abstract
- (Deck *)createDeck; // abstract
- (NSAttributedString *)titleForCard:(Card*)card; // abstract

@end

