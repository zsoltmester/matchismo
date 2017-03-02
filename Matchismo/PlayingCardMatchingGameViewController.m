//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 22..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@implementation PlayingCardMatchingGameViewController

+ (NSString *)gameName
{
	return @"PlayingCardMatchingGame";
}

- (Deck *)createDeck
{
	return [PlayingCardDeck new];
}

- (GameMode)gameMode
{
	return TwoCards;
}

- (NSUInteger)numberOfCards;
{
	return 30;
}

- (NSAttributedString *)titleForCard:(Card*)card
{
	NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
	return [[NSAttributedString alloc] initWithString:card.contents attributes:attrs];
}

- (CardView *)createCardViewWithFrame:(CGRect)frame forCard:(Card *)card
{
	PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:frame];
	cardView.rank = ((PlayingCard *)card).rank;
	cardView.suit = ((PlayingCard *)card).suit;
	cardView.faceUp = NO;
	cardView.enabled = YES;
	return cardView;
}

@end
