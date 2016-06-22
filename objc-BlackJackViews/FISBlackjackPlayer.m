//
//  FISBlackjackPlayer.m
//  BlackJack
//
//  Created by Michael Amundsen on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackPlayer.h"

@implementation FISBlackjackPlayer

- (instancetype)init {
    return [self initWithName:@"" Wins:0 Losses:0];
}

- (instancetype)initWithName:(NSString *)name Wins:(NSInteger)wins Losses:(NSInteger)losses{
    self = [super init];
    if (self) {
        _name = name;
        _cardsInHand = [@[] mutableCopy];
        _handscore = 0;
        _wins = wins;
        _losses = losses;
        _aceInHand = NO;
        _blackjack = NO;
        _busted = NO;
        _stayed = NO;
    }
    return self;
}

- (void)resetForNewGame {
    [self.cardsInHand removeAllObjects];
    self.handscore = 0;
    self.aceInHand = NO;
    self.stayed = NO;
    self.blackjack = NO;
    self.busted = NO;
}

- (void)acceptCard:(FISCard *)card {
    [self.cardsInHand addObject:card];
    
    if ([card.rank isEqualToString:[[FISCard validRanks] objectAtIndex:0]]) {
        self.aceInHand = YES;
        if (self.handscore < 11) {
            self.handscore += 10;
        }
    }
    self.handscore += card.cardValue;
    
    if (self.cardsInHand.count == 2 && self.handscore == 21) {
        self.blackjack = YES;
    }
    
    if (self.handscore > 21) {
        self.busted = YES;
    }
}

- (BOOL)shouldHit {
    if (self.handscore >= 17) {
        self.stayed = YES;
        return NO;
    }
    return YES;
}

- (NSString *)description {
    NSMutableString *playerDescription = [@"" mutableCopy];
    [playerDescription appendFormat:@"name: %@\n", self.name];
    
    NSMutableString *cardsInHand = [@"" mutableCopy];
    for (FISCard *card in self.cardsInHand) {
        [cardsInHand appendString:card.description];
    }
    [playerDescription appendFormat:@"cards: %@\n", cardsInHand];
    [playerDescription appendFormat:@"handscore: %lu\n", self.handscore];
    [playerDescription appendFormat:@"ace in hand: %d\n", self.aceInHand];
    [playerDescription appendFormat:@"stayed: %d\n", self.stayed];
    [playerDescription appendFormat:@"blackjack: %d\n", self.blackjack];
    [playerDescription appendFormat:@"busted: %d\n", self.busted];
    [playerDescription appendFormat:@"wins: %lu\n", self.wins];
    [playerDescription appendFormat:@"losses: %lu\n", self.losses];
    return playerDescription;
}

@end
