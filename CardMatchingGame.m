//
//  CardMatchingGame.m
//  DeckOCards
//
//  Created by Vimal Patel on 10/18/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property  (nonatomic,readwrite) NSInteger score;
@property  (nonatomic, strong) NSMutableArray *cards; //Array of Cards
@property  (nonatomic, strong) NSMutableArray *history; //Array of Cards


@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)history
{
    if(!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i=0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index
{
 //   NSLog(@" Number Of Cards to Match - %i", self.cardsToMatch);

    Card *card = [self cardAtIndex:index];
    BOOL foundMatch = NO;
    int numberOfMatches = 0;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            [self.history addObject:@[@"Unselected - %@", card.contents]];
            card.chosen = NO;
        } else {
           [self.history addObject:@[@"Selected - %@", card.contents]];
           int chosenCardCount = 0;
           NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            
            for(Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    chosenCardCount++;
                   [chosenCards addObject:otherCard];
                }
            }
            
            if (chosenCardCount == (self.cardsToMatch-1)) {
                //match against other chosen cards
                for(Card *otherCard in self.cards) {
                    if(otherCard.isChosen && !otherCard.isMatched){
                        NSLog(@"Matching -  %@ and %@", card.contents, otherCard.contents);
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore){
                            numberOfMatches++;
                            self.score += matchScore * MATCH_BONUS;
                            NSLog(@"score -  %i", self.score);

                          //  otherCard.matched = YES;
                            card.matched = YES;
                            foundMatch = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSLog(@"score -  %i", self.score);
                           // otherCard.chosen = foundMatch;
                        } // end of else
                    } // end of if otherCard.isChosen...
                } // end of for loop
                
                //Now match other chosen cards amongst each other
                for (Card *chosen in chosenCards){
                    for(Card *otherCard in self.cards){
                        if(otherCard.isChosen && !otherCard.isMatched && ![otherCard.contents isEqualToString:chosen.contents]){
                            NSLog(@"Matching -  %@ and %@", chosen.contents, otherCard.contents);

                            int matchScore = [chosen match:@[otherCard]];
                            if(matchScore){
                                numberOfMatches++;
                                self.score += matchScore * MATCH_BONUS;
                                NSLog(@"score -  %i", self.score);

                                foundMatch = YES;
                                chosen.matched = YES;
                            } else {
                                self.score -= MISMATCH_PENALTY;
                                NSLog(@"score -  %i", self.score);
                                // otherCard.chosen = foundMatch;
                            } // end of else
                        }

                    }
                }
                
                // if after executing match, no match is found, unchoose the cards
                if(!foundMatch){
                    for (Card *otherCard in self.cards){
                        if (otherCard.isChosen) {
                            otherCard.chosen = NO;
                        }
                    }
                } // end of if foundMatch
            }
            
            self.score -= COST_TO_CHOOSE;
            NSLog(@"score -  %i", self.score);

            card.chosen=YES;
            
            if(foundMatch){
                NSString *resultString = @"Matched ";
                
                for (Card *otherCard in self.cards){
                    if (otherCard.isChosen) {
                        [resultString stringByAppendingString:otherCard.contents];
                        otherCard.Matched = YES;
                    }
                }
                NSLog(@"%@",resultString);
            // bonus based on number of matches
                self.score += 2 * (numberOfMatches);
                NSLog(@"number of matches -  %i , score = %i", numberOfMatches, self.score);

            } // end of if foundMatch
        }
   //     NSLog(@" End of choose card at index ");

    } // end of if !card.matched

}



@end
