//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

typedef NS_ENUM(NSInteger, CardMatchingGameMode) {
	TwoCardsMode,
	ThreeCardsMode
};

typedef NS_ENUM(NSInteger, CardMatchingGameModeLastStatus) {
	MATCH,
	MISMATCH,
	NOTHING
};

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) CardMatchingGameMode mode;
@property (nonatomic, readonly) CardMatchingGameModeLastStatus lastStatus;
@property (nonatomic, strong, readonly) NSArray *lastCards; // of Card
@property (nonatomic, readonly) NSInteger lastScore;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
						usingDeck:(Deck*)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
