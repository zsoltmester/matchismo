//
//  Card.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
	for (Card *card in otherCards) {
		if ([card.contents isEqualToString:self.contents]) {
			return 1;
		}
	}

	return 0;
}

- (id)copyWithZone:(NSZone *)zone
{
	Card *copy = [[self class] new];
	copy.contents = [self.contents copyWithZone:zone];
	copy.chosen = self.chosen;
	copy.matched = self.matched;
	return copy;
}

@end
