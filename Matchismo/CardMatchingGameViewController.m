//
//  ViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "HistoryViewController.h"

@interface CardMatchingGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *history; // of CardMatchingGame
@property (strong, nonatomic) NSMutableArray *historyInfos; // of NSAttributedString

@end

@implementation CardMatchingGameViewController

NSString *const USER_DEFAULTS_HIGH_SCORES = @"HighScores";
NSString *const HIGH_SCORES_CATEGORY_SCORE = @"HighScoresCategoryScore";
NSString *const HIGH_SCORES_CATEGORY_TIME = @"HighScoresCategoryTime";

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

- (NSMutableArray *)historyInfos
{
	if (!_historyInfos) {
		_historyInfos = [[NSMutableArray alloc] init];
	}
	return _historyInfos;
}

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [self createGame];
		_game.mode = [self gameMode];
	}
	return _game;
}


+ (NSString *)gameName // abstract
{
	return nil;
}

- (GameMode)gameMode // abstract
{
	return -1;
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
	[self updateHistory];
	if ([self.game isEnded]) {
		[self saveGame];
	}
}

- (void)saveGame
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSMutableDictionary *highScores = [[userDefaults dictionaryForKey:(NSString *)USER_DEFAULTS_HIGH_SCORES] mutableCopy];
	if (!highScores) {
		highScores = [[NSMutableDictionary alloc] init];
	}

	NSMutableDictionary *gameHighScores = [[highScores objectForKey:[[self class] gameName]] mutableCopy];
	if(!gameHighScores) {
		gameHighScores = [[NSMutableDictionary alloc] init];
		[gameHighScores setObject:[[NSMutableArray alloc] init] forKey:HIGH_SCORES_CATEGORY_SCORE];
		[gameHighScores setObject:[[NSMutableArray alloc] init] forKey:HIGH_SCORES_CATEGORY_TIME];
		[highScores setObject:gameHighScores forKey:[[self class] gameName]];
	}

	NSMutableArray *scoreCategoryHighScores = [[gameHighScores objectForKey:HIGH_SCORES_CATEGORY_SCORE] mutableCopy];
	[scoreCategoryHighScores addObject:[NSNumber numberWithInteger:self.game.score]];
	NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
	[scoreCategoryHighScores sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
	if ([scoreCategoryHighScores count] > 10) {
		[scoreCategoryHighScores removeLastObject];
	}
	[gameHighScores setObject:scoreCategoryHighScores forKey:HIGH_SCORES_CATEGORY_SCORE];

	NSMutableArray *timeCategoryHighScores = [[gameHighScores objectForKey:HIGH_SCORES_CATEGORY_TIME] mutableCopy];
	[timeCategoryHighScores addObject:[NSNumber numberWithDouble:self.game.gameLasts]];
	sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
	[timeCategoryHighScores sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
	if ([timeCategoryHighScores count] > 10) {
		[timeCategoryHighScores removeLastObject];
	}
	[gameHighScores setObject:timeCategoryHighScores forKey:HIGH_SCORES_CATEGORY_TIME];

	[highScores setObject:gameHighScores forKey:[[self class] gameName]];

	[userDefaults setObject:highScores forKey:(NSString *)USER_DEFAULTS_HIGH_SCORES];
	[userDefaults synchronize];
}

- (IBAction)touchNewGameButton:(UIButton *)sender
{
	_game = [self createGame];
	[self updateUI];
	self.infoLabel.text = @"Click on a card to start the game";

	[self.history removeAllObjects];
	[self updateHistory];
	self.historySlider.enabled = NO;
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
		NSAttributedString *title = card.isChosen ? [self titleForCard:card] : [[NSAttributedString alloc] initWithString:@""];
		[cardButton setAttributedTitle:title forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
	}

	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];

	NSMutableAttributedString *lastCards = [[NSMutableAttributedString alloc] initWithString:@""];
	for (Card* lastCard in self.game.lastCards) {
		[lastCards appendAttributedString:[self titleForCard:lastCard]];
	}

	switch (self.game.lastStatus) {
		case NOTHING:
			self.infoLabel.attributedText = lastCards;
			break;
		case MATCH: {
			NSMutableAttributedString *matchText = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
			[matchText appendAttributedString:lastCards];
			[matchText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %ld points.", (long)self.game.lastScore]]];
			self.infoLabel.attributedText = matchText;
			[self.historyInfos addObject:matchText];
			break;
		}
		case MISMATCH: {
			NSMutableAttributedString *mismatchText = [[NSMutableAttributedString alloc] initWithAttributedString:lastCards];
			[mismatchText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %ld points penalty.", (long)self.game.lastScore]]];
			self.infoLabel.attributedText = mismatchText;
			[self.historyInfos addObject:mismatchText];
			break;
		}
	}

	if ([self.game isEnded]) {
		for (UIButton *cardButton in self.cardButtons) {
			cardButton.enabled = NO;
		}
		self.infoLabel.attributedText = [[NSAttributedString alloc] initWithString:@"All pairs found. Well played!"];
		[self.historyInfos addObject:[self.infoLabel.attributedText copy]];
	}
}

- (NSAttributedString *)titleForCard:(Card*)card // abstract
{
	return nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
	return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showHistorySegue"]) {
		HistoryViewController *historyViewController = [segue destinationViewController];
		historyViewController.historyInfos = self.historyInfos;
	}
}

@end
