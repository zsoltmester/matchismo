//
//  SetCard.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 23..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

typedef NS_ENUM(NSInteger, SetCardNumber) {
	SetCardNumberOne,
	SetCardNumberTwo,
	SetCardNumberThree
};

typedef NS_ENUM(NSInteger, SetCardSymbol) {
	SetCardSymbolDiamond,
	SetCardSymbolSquiggle,
	SetCardSymbolOval
};

typedef NS_ENUM(NSInteger, SetCardShading) {
	SetCardShadingSolid,
	SetCardShadingStriped,
	SetCardShadingOpen
};

typedef NS_ENUM(NSInteger, SetCardColor) {
	SetCardColorRed,
	SetCardColorGreen,
	SetCardColorPurple
};

@property (nonatomic) SetCardNumber number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;

@end
