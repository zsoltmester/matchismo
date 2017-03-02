//
//  SetCardView.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 03. 01..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setNumber:(NSUInteger)number
{
	_number = number;
	[self setNeedsDisplay];
}

- (void)setSymbol:(SetCardViewSymbol)symbol
{
	_symbol = symbol;
	[self setNeedsDisplay];
}

- (void)setShading:(SetCardViewShading)shading
{
	_shading = shading;
	[self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
	_color = color;
	[self setNeedsDisplay];
}

#define OVAL_WIDTH_MULTIPLIER 0.75
#define OVAL_HEIGHT_MULTIPLIER 0.25
#define DIAMOND_WIDTH_MULTIPLIER 0.1
#define DIAMOND_HEIGHT_MULTIPLIER 0.4
#define SQUIGGLE_WIDTH_MULTIPLIER 0.1
#define SQUIGGLE_HEIGHT_MULTIPLIER 0.4

- (void)drawCardFaceForRect:(CGRect)rect
{
	UIBezierPath *symbol;
	switch (self.symbol) {
		case SetCardViewSymbolOval:
			symbol = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + rect.size.width * (1 - OVAL_WIDTH_MULTIPLIER) / 2,
																	   rect.origin.y + rect.size.height * (1- OVAL_HEIGHT_MULTIPLIER) / 2,
																	   rect.size.width * OVAL_WIDTH_MULTIPLIER,
																	   rect.size.height * OVAL_HEIGHT_MULTIPLIER)];
			break;
		case SetCardViewSymbolDiamond:
			symbol = [UIBezierPath bezierPath];
			[symbol moveToPoint:CGPointMake(rect.origin.x + rect.size.width * DIAMOND_WIDTH_MULTIPLIER,
										 rect.origin.y + rect.size.height / 2)];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2,
											   rect.origin.y + rect.size.height * DIAMOND_HEIGHT_MULTIPLIER)];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - DIAMOND_WIDTH_MULTIPLIER),
											   rect.origin.y + rect.size.height / 2)];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2,
											   rect.origin.y + rect.size.height * (1 - DIAMOND_HEIGHT_MULTIPLIER))];
			[symbol closePath];
			break;
		case SetCardViewSymbolSquiggle:
			symbol = [UIBezierPath bezierPath];
			[symbol moveToPoint:CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_WIDTH_MULTIPLIER,
										 rect.origin.y + rect.size.height * SQUIGGLE_HEIGHT_MULTIPLIER)];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_WIDTH_MULTIPLIER),
											   rect.origin.y + rect.size.height * SQUIGGLE_HEIGHT_MULTIPLIER)];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_WIDTH_MULTIPLIER),
											   rect.origin.y + rect.size.height * (1 - SQUIGGLE_HEIGHT_MULTIPLIER))];
			[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_WIDTH_MULTIPLIER,
											   rect.origin.y + rect.size.height * (1 - SQUIGGLE_HEIGHT_MULTIPLIER))];
			[symbol closePath];
			break;
	}
	[symbol addClip];

	switch (self.shading) {
		case SetCardViewShadingSolid:
			[self.color setFill];
			[symbol fill];
			break;
		case SetCardViewShadingOpen:
			[[UIColor clearColor] setFill];
			[symbol fill];
			[self.color setStroke];
			[symbol stroke];
			break;
		case SetCardViewShadingStriped:
			[[self.color colorWithAlphaComponent:0.25] setFill];
			[symbol fill];
			[self.color setStroke];
			[symbol stroke];
			break;
	}
}

@end
