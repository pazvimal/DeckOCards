//
//  CardGameViewController.m
//  DeckOCards
//
//  Created by Vimal Patel on 10/1/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame  *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, getter = isSwitchOn) BOOL on;   // if On then 3 card match
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    
    return _game;
    
}

- (Deck *)deck
{
    if(!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
    if (self.gameModeSegmentedControl.enabled) {
        self.gameModeSegmentedControl.enabled = NO;
    }
    if(self.gameModeSwitch.enabled) {
        self.gameModeSwitch.enabled = NO;
    }
    
    if (self.gameModeSegmentedControl.selectedSegmentIndex == 0) {
        //2 card match so nothing changes
        [self updateUI];
    } else {
        // 3 card match so need to make sure 3 cards are selected
        int count = 0;
        for(UIButton *cardButton in self.cardButtons) {
            if(cardButton.isSelected)
                count += 1;
        }
        NSLog(@" Selected Cards = %i", count);
        [self updateUI];
    }
    
   // [self updateUI];
}

// re-deal function - hw2 > #2
- (IBAction)redealButton:(UIButton *)sender {
    self.game = nil;
    if (!self.gameModeSegmentedControl.enabled) {
        self.gameModeSegmentedControl.enabled = YES;
    }
    if(!self.gameModeSwitch.enabled) {
        self.gameModeSwitch.enabled = YES;
    }
    [self updateUI];
}

- (IBAction)switchGameMode:(UISwitch *)sender {
    NSLog(@" The switch is - %d", self.gameModeSwitch.isOn);
    NSLog(@" The segment control is - %d", self.gameModeSegmentedControl.selectedSegmentIndex);

}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return (card.isChosen) ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen) ? @"blankCard" : @"CardBack"];
}



@end
