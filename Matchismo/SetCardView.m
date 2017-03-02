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

#define OFFSET_MULTIPLIER 0.3
#define OVAL_WIDTH_MULTIPLIER 0.75
#define OVAL_HEIGHT_MULTIPLIER 0.2
#define DIAMOND_WIDTH_MULTIPLIER 0.1
#define DIAMOND_HEIGHT_MULTIPLIER 0.4
#define SQUIGGLE_WIDTH_MULTIPLIER 0.1
#define SQUIGGLE_HEIGHT_MULTIPLIER 0.4

- (void)drawCardFaceForRect:(CGRect)rect
{
	for (int i = 1; i <= self.number; ++i) {
		CGFloat offset = 0;
		if (self.number == 2) {
			offset = (pow(-1, i)) * rect.size.height * OFFSET_MULTIPLIER;
		} else if (self.number == 3) {
			offset = (2 - i) * rect.size.height * OFFSET_MULTIPLIER;
		}

		UIBezierPath *symbol;
		switch (self.symbol) {
			case SetCardViewSymbolOval:
				symbol = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + rect.size.width * (1 - OVAL_WIDTH_MULTIPLIER) / 2,
																		   rect.origin.y + rect.size.height * (1- OVAL_HEIGHT_MULTIPLIER) / 2 + offset,
																		   rect.size.width * OVAL_WIDTH_MULTIPLIER,
																		   rect.size.height * OVAL_HEIGHT_MULTIPLIER)];
				break;
			case SetCardViewSymbolDiamond:
				symbol = [UIBezierPath bezierPath];
				[symbol moveToPoint:CGPointMake(rect.origin.x + rect.size.width * DIAMOND_WIDTH_MULTIPLIER,
												rect.origin.y + rect.size.height / 2 + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2,
												   rect.origin.y + rect.size.height * DIAMOND_HEIGHT_MULTIPLIER + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - DIAMOND_WIDTH_MULTIPLIER),
												   rect.origin.y + rect.size.height / 2 + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2,
												   rect.origin.y + rect.size.height * (1 - DIAMOND_HEIGHT_MULTIPLIER) + offset)];
				[symbol closePath];
				break;
			case SetCardViewSymbolSquiggle:
				symbol = [UIBezierPath bezierPath];
				[symbol moveToPoint:CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_WIDTH_MULTIPLIER,
												rect.origin.y + rect.size.height * SQUIGGLE_HEIGHT_MULTIPLIER + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_WIDTH_MULTIPLIER),
												   rect.origin.y + rect.size.height * SQUIGGLE_HEIGHT_MULTIPLIER + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * (1 - SQUIGGLE_WIDTH_MULTIPLIER),
												   rect.origin.y + rect.size.height * (1 - SQUIGGLE_HEIGHT_MULTIPLIER) + offset)];
				[symbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * SQUIGGLE_WIDTH_MULTIPLIER,
												   rect.origin.y + rect.size.height * (1 - SQUIGGLE_HEIGHT_MULTIPLIER) + offset)];
				[symbol closePath];
				break;
		}

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
}

@end
