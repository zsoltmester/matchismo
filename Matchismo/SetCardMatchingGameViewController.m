//
//  SetCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCardMatchingGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardMatchingGameViewController

- (Deck *)createDeck
{
	return [SetCardDeck new];
}

- (GameMode)gameMode
{
	return ThreeCards;
}


- (NSAttributedString *)titleForCard:(Card*)card
{
	SetCard *setCard = (SetCard *)card;

	NSInteger number = setCard.number + 1;

	NSString *symbol;
	switch (setCard.symbol) {
		case Diamond:
			symbol = @"▲";
			break;
		case Squiggle:
			symbol = @"●";
			break;
		case Oval:
			symbol = @"■";
			break;
	}

	UIColor *color;
	switch (setCard.color) {
		case Red:
			color = [UIColor redColor];
			break;
		case Green:
			color = [UIColor greenColor];
			break;
		case Purple:
			color = [UIColor purpleColor];
			break;
	}

	NSNumber *strokeWidth = @(0);
	UIColor *strokeColor = color;
	NSNumber *underline = @(NSUnderlineStyleNone);
	switch (setCard.shading) {
		case Solid:
			// nothing to do here
			break;
		case Striped:
			underline = @(NSUnderlineStyleSingle);
			break;
		case Open:
			strokeWidth = @(-3.0);
			color = [color colorWithAlphaComponent:0.1];
			break;
	}

	NSDictionary *attrs = @{ NSForegroundColorAttributeName : color,
							 NSStrokeWidthAttributeName: strokeWidth,
							 NSStrokeColorAttributeName: strokeColor,
							 NSUnderlineStyleAttributeName: underline,
							 NSUnderlineColorAttributeName: color };

	return [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@", number, symbol] attributes:attrs];
}

@end
