//
//  HighScoresViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 02. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "HighScoresViewController.h"
#import "CardMatchingGameViewController.h"
#import "PlayingCardMatchingGameViewController.h"
#import "SetCardMatchingGameViewController.h"

@interface HighScoresViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *listTextView;
@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation HighScoresViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.formatter = [NSNumberFormatter new];
	[self.formatter setMaximumFractionDigits:2];
	[self.formatter setRoundingMode:NSNumberFormatterRoundDown];
}

- (void)updateUI
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSDictionary *highScores = [userDefaults dictionaryForKey:USER_DEFAULTS_HIGH_SCORES];
	if (!highScores) {
		self.listTextView.text = @"No data for the selected types.";
		return;
	}

	NSString *gameName;
	switch (self.gameSegmentedControl.selectedSegmentIndex) {
		case 0:
			gameName = [PlayingCardMatchingGameViewController gameName];
			break;
		case 1:
			gameName = [SetCardMatchingGameViewController gameName];
			break;
	}
	NSDictionary *gameHighScores = [highScores objectForKey:gameName];
	if (!gameHighScores) {
		self.listTextView.text = @"No data for the selected types.";
		return;
	}

	NSString *category;
	switch (self.categorySegmentedControl.selectedSegmentIndex) {
		case 0:
			category = HIGH_SCORES_CATEGORY_SCORE;
			break;
		case 1:
			category = HIGH_SCORES_CATEGORY_TIME;
			break;
	}
	NSArray *categoryHighScores = [gameHighScores objectForKey:category];
	if (!categoryHighScores || [categoryHighScores count] == 0) {
		self.listTextView.text = @"No data for the selected types.";
		return;
	}

	NSMutableString *list = [NSMutableString string];
	for (int i = 0; i < [categoryHighScores count]; ++i) {
		if (category == HIGH_SCORES_CATEGORY_SCORE) {
			[list appendString:[NSString stringWithFormat:@"%d. %@\n", i + 1, categoryHighScores[i]]];
		} else {
			[list appendString:[NSString stringWithFormat:@"%d. %@ sec\n", i + 1, [self.formatter stringFromNumber:categoryHighScores[i]]]];
		}
	}

	self.listTextView.text = list;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUI];
}

- (IBAction)onCategoryValueChanged:(UISegmentedControl *)sender
{
	[self updateUI];
}

- (IBAction)onGameValueChanged:(UISegmentedControl *)sender
{
	[self updateUI];
}

@end
