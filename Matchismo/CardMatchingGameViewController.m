//
//  ViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardMatchingGameViewController.h"

#import "CardMatchingGame.h"

@interface CardMatchingGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) NSMutableArray *history; // of CardMatchingGame

@end

@implementation CardMatchingGameViewController

- (void)viewDidLoad
{
	self.historySlider.continuous = YES;
	self.historySlider.minimumValue = 0;
	[self updateHistory];
	self.historySlider.enabled = NO;
}

- (NSMutableArray *)history
{
	if (!_history) {
		_history = [[NSMutableArray alloc] init];
	}
	return _history;
}

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [self createGame];
	}
	return _game;
}

- (Deck *)createDeck // abstract
{
	return nil;
}

- (CardMatchingGame *)createGame
{
	return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
											 usingDeck:[self createDeck]];
}

- (void)updateHistory
{
	[self.history addObject:[self.game copy]];
	self.historySlider.enabled = YES;
	self.historySlider.maximumValue = [self.history count] - 1;
	if (self.historySlider.maximumValue == 0) {
		self.historySlider.maximumValue = 1;
	}
	self.historySlider.value = self.historySlider.maximumValue;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
	if (self.historySlider.value != self.historySlider.maximumValue) {
		return;
	}

	NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:chosenButtonIndex];
	[self updateUI];
	self.modeSegmentControl.enabled = NO;
	[self updateHistory];
}

- (IBAction)touchNewGameButton:(UIButton *)sender
{
	_game = [self createGame];
	self.game.mode = self.modeSegmentControl.selectedSegmentIndex == 0 ? TwoCardsMode : ThreeCardsMode;
	[self updateUI];
	self.modeSegmentControl.enabled = YES;
	self.infoLabel.text = @"Click on a card to start the game";

	[self.history removeAllObjects];
	[self updateHistory];
	self.historySlider.enabled = NO;
}

- (IBAction)modeSegmentControlChange:(UISegmentedControl *)sender
{
	self.game.mode = sender.selectedSegmentIndex == 0 ? TwoCardsMode : ThreeCardsMode;
}

- (IBAction)historySliderChanged:(UISlider *)sender
{
	NSUInteger index = (NSUInteger)(sender.value + 0.5);
	[sender setValue:index animated:NO];
	self.game = self.history[index];
	[self updateUI];
}

- (void)updateUI
{
	for (UIButton *cardButton in self.cardButtons) {
		NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
		Card *card = [self.game cardAtIndex:cardButtonIndex];
		[cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
		NSMutableString *lastCards = [NSMutableString string];
		for (Card* lastCard in self.game.lastCards) {
			[lastCards appendString:[NSString stringWithFormat:@"%@ ", lastCard.contents]];
		}
		switch (self.game.lastStatus) {
			case NOTHING:
				self.infoLabel.text = [NSString stringWithString:lastCards];
				break;
			case MATCH:
				self.infoLabel.text = [NSString stringWithFormat:@"Matched %@ for %ld points.", lastCards, self.game.lastScore];
				break;
			case MISMATCH:
				self.infoLabel.text = [NSString stringWithFormat:@"%@ don't match! %ld points penalty.", lastCards, self.game.lastScore];
				break;
		}
	}
}

- (NSString *)titleForCard:(Card*)card
{
	return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
	return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
