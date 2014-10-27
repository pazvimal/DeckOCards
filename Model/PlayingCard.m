//
//  PlayingCard.m
//  DeckOCards
//
//  Created by Vimal Patel on 10/1/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
            NSLog(@"Matched rank for %@ and %@", self.contents, otherCard.contents);
        } else if (otherCard.suit == self.suit) {
            
            NSLog(@"Matched suit for %@ and %@", self.contents, otherCard.contents);

            score = 1;
        }
    }
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♣️",@"♥️",@"♦️",@"♠️"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
        
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
- (NSString *)suit
{
    return _suit ? _suit : @"?";
    
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] -1;
}


@end
