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

@end
