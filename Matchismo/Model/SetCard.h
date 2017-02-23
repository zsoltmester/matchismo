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
	One,
	Two,
	Three
};

typedef NS_ENUM(NSInteger, SetCardSymbol) {
	Diamond,
	Squiggle,
	Oval
};

typedef NS_ENUM(NSInteger, SetCardShading) {
	Solid,
	Striped,
	Open
};

typedef NS_ENUM(NSInteger, SetCardColor) {
	Red,
	Green,
	Purple
};

@property (nonatomic) SetCardNumber number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;

@end
