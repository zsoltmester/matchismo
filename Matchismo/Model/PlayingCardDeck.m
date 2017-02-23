//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init
{
	self = [super init];

	if (self) {
		for (NSString *suit in [PlayingCard validSuits]) {
			for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; ++rank) {
				PlayingCard *card = [PlayingCard new];
				card.suit = suit;
				card.rank = rank;
				[self addCard:card];
			}
		}
	}

	return self;
}

@end
