//
//  Game.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) GameLastStatus lastStatus;
@property (nonatomic, strong, readwrite) NSArray *lastCards; // of Card
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, readwrite) BOOL isEnded;
@property (nonatomic, readwrite) NSTimeInterval gameLasts;
@property (nonatomic, strong) NSDate *start;

@end

@implementation CardMatchingGame

static const int COST_TO_CHOOSE = 1;
static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;

- (instancetype)initWithCardCount:(NSUInteger)count
						usingDeck:(Deck *)deck
{
	self = [super init];

	if (self) {
		self.cards = [NSMutableArray new];
		for (int i = 0; i < count; ++i) {
			Card *card = [deck drawRandomCard];
			if (card) {
				[self.cards addObject:card];
			} else {
				self = nil;
				break;
			}
		}
		self.lastStatus = NOTHING;
	}

	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	CardMatchingGame *copy = [[self class] new];
	copy.score = self.score;
	copy.mode = self.mode;
	copy.cards = [[NSMutableArray alloc] initWithArray:self.cards copyItems:YES];
	copy.lastStatus = self.lastStatus;
	copy.lastCards = [[NSMutableArray alloc] initWithArray:self.lastCards copyItems:YES];
	copy.lastScore = self.lastScore;
	return copy;
}

- (NSArray *)getChosenCards
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chosen = YES AND matched = NO"];
	return [self.cards filteredArrayUsingPredicate:predicate];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
	if (!self.start) {
		self.start = [NSDate date];
	}

	Card *card = [self cardAtIndex:index];

	if (card.isMatched) {
		self.lastStatus = NOTHING;
		return;
	}

	if (card.isChosen) {
		card.chosen = NO;
		self.lastStatus = NOTHING;
		self.lastCards = [self getChosenCards];
		return;
	}

	self.score -= COST_TO_CHOOSE;

	NSMutableArray *otherCards = [[NSMutableArray alloc] init];
	for (Card *otherCard in self.cards) {
		if (otherCard.isChosen && !otherCard.isMatched) {
			[otherCards addObject:otherCard];
		}
	}

	card.chosen = YES;
	self.lastCards = [self getChosenCards];

	if ([otherCards count] + 1 < (self.mode == TwoCards ? 2 : 3)) {
		self.lastStatus = NOTHING;
		return;
	}

	int matchScore = [card match:otherCards];
	if (matchScore) {
		self.lastScore = matchScore * MATCH_BONUS;
		self.score += self.lastScore;
		card.matched = YES;
		for (Card *otherCard in otherCards) {
			otherCard.matched = YES;
		}
		self.lastStatus = MATCH;
	} else {
		self.lastScore = MISMATCH_PENALTY;
		self.score -= self.lastScore;
		for (Card *otherCard in otherCards) {
			otherCard.chosen = NO;
		}
		self.lastStatus = MISMATCH;
	}

	if ([self isEnded]) {
		self.gameLasts = -[self.start timeIntervalSinceNow];
	}
}

- (BOOL)isEnded
{
	NSMutableArray *notMatched = [[NSMutableArray alloc] init];
	for (Card *card in self.cards) {
		if (!card.isMatched) {
			[notMatched addObject:card];
		}
	}

	if ([notMatched count] == 0) {
		return YES;
	}

	switch (self.mode) {
		case TwoCards:
			for (Card *card1 in notMatched) {
				for (Card *card2 in notMatched) {
					if (![card1 isEqual:card2] && [card1 match:[NSArray arrayWithObject:card2]]) {
						return NO;
					}
				}
			}
			break;
		case ThreeCards:
			for (Card *card1 in notMatched) {
				for (Card *card2 in notMatched) {
					for (Card *card3 in notMatched) {
						if (![card1 isEqual:card2] && ![card1 isEqual:card3] && ![card2 isEqual:card3] && [card1 match:[NSArray arrayWithObjects:card2,card3,nil]]) {
							return NO;
						}
					}
				}
			}
			break;
	}

	return YES;
}

@end
