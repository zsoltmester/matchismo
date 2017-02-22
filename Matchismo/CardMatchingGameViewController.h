//
//  ViewController.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Deck.h"

// abstract
@interface CardMatchingGameViewController : UIViewController

- (Deck *)createDeck; // abstract

@end

