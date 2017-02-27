//
//  Game.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

typedef NS_ENUM(NSInteger, GameLastStatus) {
	MATCH,
	MISMATCH,
	NOTHING
};

typedef NS_ENUM(NSInteger, GameMode) {
	TwoCards,
	ThreeCards
};

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) GameMode mode;
@property (nonatomic, readonly) GameLastStatus lastStatus;
@property (nonatomic, strong, readonly) NSArray *lastCards; // of Card
@property (nonatomic, readonly) NSInteger lastScore;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
						usingDeck:(Deck*)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)isEnded;

@end
