//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 22..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardMatchingGameViewController

- (Deck *)createDeck
{
	return [PlayingCardDeck new];
}

- (GameMode)gameMode
{
	return TwoCards;
}


- (NSAttributedString *)titleForCard:(Card*)card
{
	NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
	return [[NSAttributedString alloc] initWithString:card.contents attributes:attrs];
}

@end
