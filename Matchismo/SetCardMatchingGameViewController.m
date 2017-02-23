//
//  SetCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCardMatchingGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardMatchingGameViewController

- (Deck *)createDeck
{
	return [SetCardDeck new];
}

- (GameMode)gameMode
{
	return ThreeCards;
}


- (NSString *)titleForCard:(Card*)card
{
	if (!card.isChosen || ![card isKindOfClass:[SetCard class]]) {
		return @"";
	}

	SetCard *setCard = (SetCard *)card;
	return [NSString stringWithFormat:@"%ld %ld %ld %ld", (long)setCard.number, (long)setCard.symbol, (long)setCard.shading, (long)setCard.color];
}

@end
