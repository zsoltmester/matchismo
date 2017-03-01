//
//  ViewController.m
//  Matchismo
//
//  Created by Zsolt Mester on 2017. 01. 28..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "HistoryViewController.h"
#import "Grid.h"

@interface CardMatchingGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (strong, nonatomic) Grid* grid;
@property (strong, nonatomic) NSMutableArray *cards; // of CardView
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) BOOL inHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *history; // of CardMatchingGame
@property (strong, nonatomic) NSMutableArray *historyInfos; // of NSAttributedString

@end

@implementation CardMatchingGameViewController

NSString *const USER_DEFAULTS_HIGH_SCORES = @"HighScores";
NSString *const HIGH_SCORES_CATEGORY_SCORE = @"HighScoresCategoryScore";
NSString *const HIGH_SCORES_CATEGORY_TIME = @"HighScoresCategoryTime";

static const CGFloat CELL_ASPECT_RATIO = 0.66;

- (void)setup
{
	self.game = [self createGame];
	self.game.mode = [self gameMode];

	self.inHistory = NO;
	self.history = [NSMutableArray new];
	self.historyInfos = [NSMutableArray new];
	self.historySlider.continuous = YES;
	self.historySlider.minimumValue = 0;
	[self addStateToHistory];
	self.historySlider.enabled = NO;

	self.grid = [Grid new];
	self.grid.size = self.cardContainerView.bounds.size;
	self.grid.cellAspectRatio = CELL_ASPECT_RATIO;
	self.grid.minimumNumberOfCells = [self numberOfCards];

	self.cards = [NSMutableArray new];
	for (int row = 0; row < self.grid.rowCount; ++row) {
		for (int column = 0; column < self.grid.columnCount; ++column) {
			CardView *cardView = [self createCardViewWithFrame:[self.grid frameOfCellAtRow:row inColumn:column] forCard:[self.game cardAtIndex:(column + row * self.grid.columnCount)]];
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCardView:)];
			[cardView addGestureRecognizer:tapGestureRecognizer];
			[self.cards addObject:cardView];
			[self.cardContainerView addSubview:cardView];
		}
	}

	self.infoLabel.text = @"Click on a card to start the game";
}

- (void)viewDidLoad
{
	[self setup];
}

- (IBAction)touchNewGameButton:(UIButton *)sender
{
	[self setup];
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

- (NSUInteger)numberOfCards; // abstract
{
	return 0;
}

- (CardView *)createCardViewWithFrame:(CGRect)frame forCard:(Card *)card; // abstract
{
	return nil;
}

- (NSAttributedString *)titleForCard:(Card*)card // abstract
{
	return nil;
}

- (CardMatchingGame *)createGame
{
	return [[CardMatchingGame alloc] initWithCardCount:[self numberOfCards]
											 usingDeck:[self createDeck]];
}

- (void)addStateToHistory
{
	[self.history addObject:[self.game copy]];
	self.historySlider.maximumValue = [self.history count] - 1;
	if (self.historySlider.maximumValue == 0) {
		self.historySlider.maximumValue = 1;
	} else {
		self.historySlider.enabled = YES;
	}
	self.historySlider.value = self.historySlider.maximumValue;

	if (self.game.lastStatus == MATCH || self.game.lastStatus == MISMATCH)
	[self.historyInfos addObject:[self.infoLabel.attributedText copy]];
}


- (IBAction)historySliderChanged:(UISlider *)sender
{
	NSUInteger index = (NSUInteger)(sender.value + 0.5);
	[sender setValue:index animated:NO];
	self.game = self.history[index];
	self.inHistory = index != sender.maximumValue;
	[self updateUI];
}

- (void)touchCardView:(UITapGestureRecognizer *)gestureRecognizer
{
	if (self.inHistory || !((CardView *)gestureRecognizer.view).enabled) {
		return;
	}

	NSUInteger chosenCardViewIndex = [self.cards indexOfObject:gestureRecognizer.view];
	[self.game chooseCardAtIndex:chosenCardViewIndex];

	[self updateUI];

	[self addStateToHistory];

	if ([self.game isEnded]) {
		[self saveGame];
	}
}

- (void)saveGame
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSMutableDictionary *highScores = [[userDefaults dictionaryForKey:(NSString *)USER_DEFAULTS_HIGH_SCORES] mutableCopy];
	if (!highScores) {
		highScores = [[NSMutableDictionary alloc] initWithCapacity:2];
	}

	NSMutableDictionary *gameHighScores = [[highScores objectForKey:[[self class] gameName]] mutableCopy];
	if(!gameHighScores) {
		gameHighScores = [[NSMutableDictionary alloc] initWithCapacity:2];
		gameHighScores[HIGH_SCORES_CATEGORY_SCORE] = [[NSMutableArray alloc] initWithCapacity:1];
		gameHighScores[HIGH_SCORES_CATEGORY_TIME] = [[NSMutableArray alloc] initWithCapacity:1];
		highScores[[[self class] gameName]] = gameHighScores;
	}

	NSMutableArray *scoreCategoryHighScores = [gameHighScores[HIGH_SCORES_CATEGORY_SCORE] mutableCopy];
	[scoreCategoryHighScores addObject:[NSNumber numberWithInteger:self.game.score]];
	NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
	[scoreCategoryHighScores sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
	if ([scoreCategoryHighScores count] > 10) {
		[scoreCategoryHighScores removeLastObject];
	}
	gameHighScores[HIGH_SCORES_CATEGORY_SCORE] = scoreCategoryHighScores;

	NSMutableArray *timeCategoryHighScores = [gameHighScores[HIGH_SCORES_CATEGORY_TIME] mutableCopy];
	[timeCategoryHighScores addObject:[NSNumber numberWithDouble:self.game.gameLasts]];
	sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
	[timeCategoryHighScores sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
	if ([timeCategoryHighScores count] > 10) {
		[timeCategoryHighScores removeLastObject];
	}
	gameHighScores[HIGH_SCORES_CATEGORY_TIME] = timeCategoryHighScores;

	highScores[[[self class] gameName]] = gameHighScores;

	[userDefaults setObject:highScores forKey:(NSString *)USER_DEFAULTS_HIGH_SCORES];
	[userDefaults synchronize];
}

- (void)updateUI
{
	for (CardView *cardView in self.cards) {
		NSUInteger cardViewIndex = [self.cards indexOfObject:cardView];
		Card *card = [self.game cardAtIndex:cardViewIndex];
		cardView.faceUp = card.isChosen;
		cardView.enabled = !card.isMatched;
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
			break;
		}
		case MISMATCH: {
			NSMutableAttributedString *mismatchText = [[NSMutableAttributedString alloc] initWithAttributedString:lastCards];
			[mismatchText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %ld points penalty.", (long)self.game.lastScore]]];
			self.infoLabel.attributedText = mismatchText;
			break;
		}
	}

	if ([self.game isEnded]) {
		for (CardView *cardView in self.cards) {
			cardView.enabled = NO;
		}
		self.infoLabel.attributedText = [[NSAttributedString alloc] initWithString:@"All pairs found. Well played!"];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showHistorySegue"]) {
		HistoryViewController *historyViewController = [segue destinationViewController];
		historyViewController.historyInfos = self.historyInfos;
	}
}

@end
