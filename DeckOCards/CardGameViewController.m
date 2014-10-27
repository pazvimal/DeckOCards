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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (strong, nonatomic) NSString *matchMode;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    
    return _game;
    
}

-(NSString *)matchMode
{
    return [self.gameModeSegmentedControl titleForSegmentAtIndex:self.gameModeSegmentedControl.selectedSegmentIndex];
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
    
    if (self.gameModeSegmentedControl.enabled) {
        self.gameModeSegmentedControl.enabled = NO;
        self.game.cardsToMatch= [self.matchMode intValue];

    }
    
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
   
   [self updateUI];
}

// re-deal function - hw2 > #2
- (IBAction)redealButton:(UIButton *)sender {
    self.game = nil;
    if (!self.gameModeSegmentedControl.enabled) {
        self.gameModeSegmentedControl.enabled = YES;
    }
    [self updateUI];
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
