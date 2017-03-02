//
//  SetCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCardMatchingGameViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardMatchingGameViewController

+ (NSString *)gameName
{
	return @"SetCardMatchingGame";
}

- (Deck *)createDeck
{
	return [SetCardDeck new];
}

- (GameMode)gameMode
{
	return ThreeCards;
}

- (NSUInteger)numberOfCards;
{
	return 30;
}

- (NSAttributedString *)titleForCard:(Card*)card
{
	SetCard *setCard = (SetCard *)card;

	NSInteger number = setCard.number + 1;

	NSString *symbol;
	switch (setCard.symbol) {
		case SetCardSymbolDiamond:
			symbol = @"▲";
			break;
		case SetCardSymbolOval:
			symbol = @"●";
			break;
		case SetCardSymbolSquiggle:
			symbol = @"■";
			break;
	}

	UIColor *color;
	switch (setCard.color) {
		case SetCardColorRed:
			color = [UIColor redColor];
			break;
		case SetCardColorGreen:
			color = [UIColor greenColor];
			break;
		case SetCardColorPurple:
			color = [UIColor purpleColor];
			break;
	}

	NSNumber *strokeWidth = @(0);
	UIColor *strokeColor = color;
	switch (setCard.shading) {
		case SetCardShadingSolid:
			// nothing to do here
			break;
		case SetCardShadingStriped:
			color = [color colorWithAlphaComponent:0.25];
			break;
		case SetCardShadingOpen:
			strokeWidth = @(-3.0);
			color = [UIColor clearColor];
			break;
	}

	NSDictionary *attrs = @{ NSForegroundColorAttributeName : color,
							 NSStrokeWidthAttributeName: strokeWidth,
							 NSStrokeColorAttributeName: strokeColor,
							 NSUnderlineColorAttributeName: color };

	return [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@", number, symbol] attributes:attrs];
}

- (CardView *)createCardViewWithFrame:(CGRect)frame forCard:(Card *)card
{
	SetCardView *cardView = [[SetCardView alloc] initWithFrame:frame];
	switch (((SetCard *)card).number) {
		case SetCardNumberOne:
			cardView.number = 1;
			break;
		case SetCardNumberTwo:
			cardView.number = 2;
			break;
		case SetCardNumberThree:
			cardView.number = 3;
			break;
	}
	switch (((SetCard *)card).color) {
		case SetCardColorGreen:
			cardView.color = [UIColor greenColor];
			break;
		case SetCardColorRed:
			cardView.color = [UIColor redColor];
			break;
		case SetCardColorPurple:
			cardView.color = [UIColor purpleColor];
			break;
	}
	switch (((SetCard *)card).symbol) {
		case SetCardSymbolDiamond:
			cardView.symbol = SetCardViewSymbolDiamond;
			break;
		case SetCardSymbolOval:
			cardView.symbol = SetCardViewSymbolOval;
			break;
		case SetCardSymbolSquiggle:
			cardView.symbol = SetCardViewSymbolSquiggle;
			break;
	}
	switch (((SetCard *)card).shading) {
		case SetCardShadingOpen:
			cardView.shading = SetCardViewShadingOpen;
			break;
		case SetCardShadingStriped:
			cardView.shading = SetCardViewShadingStriped;
			break;
		case SetCardShadingSolid:
			cardView.shading = SetCardViewShadingSolid;
			break;
	}
	cardView.faceUp = YES;
	cardView.enabled = YES;
	return cardView;
}

@end
