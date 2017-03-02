//
//  CardView.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 03. 01..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (void)setEnabled:(BOOL)enabled
{
	_enabled = enabled;
	[self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
	_faceUp = faceUp;
	[self setNeedsDisplay];
}

- (void)setup
{
	self.backgroundColor = nil;
	self.opaque = NO;
	self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor
{
	return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius
{
	return CORNER_RADIUS * [self cornerScaleFactor];
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];

	[roundedRect addClip];

	[[UIColor whiteColor] setFill];
	[roundedRect fill];

	[[UIColor blackColor] setStroke];
	[roundedRect stroke];

	if (self.faceUp) {
		[self drawCardFaceForRect:rect];
	} else {
		[[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
	}

	if (!self.enabled) {
		[[[UIColor blackColor] colorWithAlphaComponent:0.2] setFill];
		[roundedRect fill];
	}
}

- (void)drawCardFaceForRect:(CGRect)rect // abstract
{
}

@end
