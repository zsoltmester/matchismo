//
//  SetCard.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

static const int SCORE_MATCH = 1;

- (int)match:(NSArray *)otherCards
{
	NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
	[cards addObject:self];
	for (NSString *feature in @[@"number", @"symbol", @"shading", @"color"]) {
		if (![SetCard matchFeature:feature forCards:cards]) {
			return 0;
		}
	}

	return SCORE_MATCH;
}

+ (BOOL)matchFeature:(NSString *)feature
			forCards:(NSArray *)cards
{
	id featureForCardOne = [cards[0] valueForKey:feature];
	id featureForCardTwo = [cards[1] valueForKey:feature];
	id featureForCardThree = [cards[2] valueForKey:feature];

	return (featureForCardOne == featureForCardTwo && featureForCardOne == featureForCardThree) || (featureForCardOne != featureForCardTwo && featureForCardOne != featureForCardThree && featureForCardTwo != featureForCardThree);
}

@end
