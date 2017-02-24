//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "HistoryViewController.h"
#import "CardMatchingGame.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
	NSMutableAttributedString *history = [[NSMutableAttributedString alloc] initWithString:@""];
	for (int i = 0; i < [self.historyInfos count]; ++i) {
		[history appendAttributedString:self.historyInfos[i]];
		[history appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
	}
	self.historyTextView.attributedText = history;
}

@end
