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

- (BOOL)isEqual:(id)object
{
	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[SetCard class]]) {
		return NO;
	}

	SetCard *other = object;
	return self.number == other.number && self.symbol == other.symbol && self.shading == other.shading && self.color == other.color;
}

- (id)copyWithZone:(NSZone *)zone
{
	SetCard *copy = [super copyWithZone:zone];
	copy.number = self.number;
	copy.symbol = self.symbol;
	copy.shading = self.shading;
	copy.color = self.color;
	return copy;
}

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
	NSInteger featureForCardOne = (NSInteger)[cards[0] valueForKey:feature];
	NSInteger featureForCardTwo = (NSInteger)[cards[1] valueForKey:feature];
	NSInteger featureForCardThree = (NSInteger)[cards[2] valueForKey:feature];

	return (featureForCardOne == featureForCardTwo && featureForCardOne == featureForCardThree) || (featureForCardOne != featureForCardTwo && featureForCardOne != featureForCardThree && featureForCardTwo != featureForCardThree);
}

@end
