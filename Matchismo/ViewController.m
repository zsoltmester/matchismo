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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) Deck *deck;

@end

@implementation ViewController

@synthesize deck = _deck;

- (Deck *)deck
{
	if (!_deck) {
		//NSLog(@"Initializing new Deck instance.");
		_deck = [[PlayingCardDeck alloc] init];
	}

	return _deck;
}

- (void)setFlipCount:(int)flipCount
{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
	NSLog(@"flipCount changed to: %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
	if ([sender.currentTitle length]) {
		[sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
						  forState:UIControlStateNormal];
		[sender setTitle:@"" forState:UIControlStateNormal];
	} else {
		[sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
						  forState:UIControlStateNormal];
		NSString *title = [self.deck drawRandomCard].contents;
		if (![title length]) {
			NSLog(@"Deck is empty!");
			title = @"?";
		}
		[sender setTitle:title forState:UIControlStateNormal];
	}
	self.flipCount++;
}

@end
