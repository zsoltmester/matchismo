//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 22..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardMatchingGameViewController ()

@end

@implementation PlayingCardMatchingGameViewController

- (Deck *)createDeck
{
	return [PlayingCardDeck new];
}

@end
