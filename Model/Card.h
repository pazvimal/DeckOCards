//
//  Card.h
//  DeckOCards
//
//  Created by Vimal Patel on 10/1/14.
//  Copyright (c) 2014 vimal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *) otherCards;

@end
