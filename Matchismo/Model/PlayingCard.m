//
//  PlayingCard.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

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
