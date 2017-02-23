//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
	self = [super init];

	if (self) {
		for (int number = 0; number < 3; ++number) {
			for (int symbol = 0; symbol < 3; ++symbol) {
				for (int shading = 0; shading < 3; ++shading) {
					for (int color = 0; color < 3; ++color) {
						SetCard *card = [SetCard new];
						card.number = number;
						card.symbol = symbol;
						card.shading = shading;
						card.color = color;
						[self addCard:card];
					}
				}
			}
		}
	}

	return self;
}

@end
