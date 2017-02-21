//
//  ViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "ViewController.h"

#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation ViewController

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [self createGame];
	}
	return _game;
}

- (Deck *)createDeck
{
	return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGame
{
	return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
											 usingDeck:[self createDeck]];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
	NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:chosenButtonIndex];
	[self updateUI];
	self.modeSwitch.enabled = NO;
}

- (IBAction)touchNewGameButton:(UIButton *)sender
{
	_game = [self createGame];
	[self updateUI];
	self.modeSwitch.enabled = YES;
	self.infoLabel.text = @"Click on a card to start the game";
}

- (IBAction)modeSwitchChanged:(UISwitch *)sender {
	self.game.mode = sender.isOn ? ThreeCardsMode : TwoCardsMode;
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
