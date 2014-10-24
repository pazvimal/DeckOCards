//
//  Deck.h
//  DeckOCards
//
//  Created by Vimal Patel on 10/1/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
