//
//  CardMatchingGame.h
//  DeckOCards
//
//  Created by Vimal Patel on 10/18/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic) NSInteger cardsToMatch;
@property (nonatomic, strong) NSString *lastActionText;

@end
