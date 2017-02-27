//
//  PlayingCard.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

static const int SCORE_MATCHING_RANK = 4;
static const int SCORE_MATCHING_SUIT = 1;

- (BOOL)isEqual:(id)object
{
	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[PlayingCard class]]) {
		return NO;
	}

	PlayingCard *other = object;
	return [self.suit isEqual:other.suit] && self.rank == other.rank;
}

- (id)copyWithZone:(NSZone *)zone
{
	PlayingCard *copy = [super copyWithZone:zone];
	copy.suit = self.suit;
	copy.rank = self.rank;
	return copy;
}

- (int)match:(NSArray *)otherCards
{
	NSMutableArray *allCards = [[NSMutableArray alloc] initWithArray:otherCards];
	[allCards addObject:self];

	return [PlayingCard match:allCards];
}

+ (int)match:(NSArray *)cards
{
	int score = 0;

	for (NSString *suit in [PlayingCard validSuits]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suit = %@", suit];
		NSUInteger matched = [[cards filteredArrayUsingPredicate:predicate] count];
		if (matched > 1) {
			score += SCORE_MATCHING_SUIT * (pow(matched - 1, 2));
		}
	}

	for (int rank = 0; rank <= [PlayingCard maxRank]; ++rank) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rank = %d", rank];
		NSUInteger matched = [[cards filteredArrayUsingPredicate:predicate] count];
		if (matched > 1) {
			score += SCORE_MATCHING_RANK * (pow(matched - 1, 2));
		}
	}

	return score;
}

- (NSString *)contents
{
	NSArray *rankStrings = [PlayingCard rankStrings];
	return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
	return @[@"♠︎",@"♣︎",@"♥︎",@"♦︎"];
}

- (void)setSuit:(NSString *)suit
{
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit
{
	return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
	return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
	return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
	if (rank <= [PlayingCard maxRank]) {
		_rank = rank;
	}
}

@end
