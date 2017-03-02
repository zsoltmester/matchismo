//
//  CardView.h
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 03. 01..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL faceUp;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;

- (void)drawCardFaceForRect:(CGRect)rect; // abstract

@end
