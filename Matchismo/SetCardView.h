//
//  SetCardView.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 03. 01..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

typedef NS_ENUM(NSInteger, SetCardViewSymbol) {
	SetCardViewSymbolDiamond,
	SetCardViewSymbolSquiggle,
	SetCardViewSymbolOval
};

typedef NS_ENUM(NSInteger, SetCardViewShading) {
	SetCardViewShadingSolid,
	SetCardViewShadingStriped,
	SetCardViewShadingOpen
};

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardViewSymbol symbol;
@property (nonatomic) SetCardViewShading shading;
@property (nonatomic) UIColor *color;

@end
