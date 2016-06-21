//
//  FISCard.m
//  OOP-Cards-Model
//
//  Created by Michael Amundsen on 6/15/16.
//  Copyright © 2016 Al Tyus. All rights reserved.
//

#import "FISCard.h"

@interface FISCard ()

@property (strong, nonatomic, readwrite) NSString *suit;
@property (strong, nonatomic, readwrite) NSString *rank;
@property (strong, nonatomic, readwrite) NSString *cardLabel;
@property (nonatomic, readwrite) NSUInteger cardValue;

@end

@implementation FISCard

- (instancetype)init {
    return [self initWithSuit:@"!" rank:@"N"];
}

- (instancetype)initWithSuit:(NSString *)suit rank:(NSString *)rank {
    self = [super init];
    if (self) {
        _suit = suit;
        _rank = rank;
        _cardLabel = [NSString stringWithFormat:@"%@%@", _suit, _rank];
        NSUInteger cardValue = [[FISCard validRanks] indexOfObject:rank] + 1;
        _cardValue = cardValue <= 10? cardValue : 10;
//        if (cardValue <= 10) {
//            _cardValue = cardValue;
//        } else {
//            _cardValue = 10;
//        }
    }
    return self;
}

+ (NSArray *)validSuits {
    return @[@"♠", @"♥", @"♣", @"♦"];
}

+ (NSArray *)validRanks {
    return @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

- (NSString *)description {
    return self.cardLabel;
}

@end
