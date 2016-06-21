//
//  FISBlackjackGame.m
//  BlackJack
//
//  Created by Michael Amundsen on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"
#import "FISCard.h"

@implementation FISBlackjackGame

- (instancetype)init {
    self = [super init];
    if (self) {
        _deck = [[FISCardDeck alloc] init];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
    }
    return self;
}

- (void)playBlackjack {
    [self.deck resetDeck];
    [self.player resetForNewGame];
    [self.house resetForNewGame];
    [self dealNewRound];
    
    for (NSUInteger i = 0; i < 3; i++) {
        [self processPlayerTurn];
        if (self.player.busted) {
            break;
        }
        
        [self processHouseTurn];
        if (self.house.busted) {
            break;
        }
    }
    
    BOOL houseWins = [self houseWins];
    [self incrementWinsAndLossesForHouseWins:houseWins];
    
    NSLog(@"%@", self.player);
    NSLog(@"%@", self.house);
}

- (void)dealNewRound {
    [self.deck shuffleRemainingCards];
    for (NSUInteger i = 0; i < 2; i++) {
        [self dealCardToPlayer];
        [self dealCardToHouse];
    }
    
}

- (void)dealCardToPlayer {
    [self.player acceptCard:[self.deck drawNextCard]];
    
}

- (void)dealCardToHouse {
    [self.house acceptCard:[self.deck drawNextCard]];
    
}

- (void)processPlayerTurn {
    if ([self.player shouldHit] && !(self.player.stayed) && !(self.player.busted)) {
        [self dealCardToPlayer];
    }
}

- (void)processHouseTurn {
    if ([self.house shouldHit] && !(self.house.stayed) && !(self.house.busted)) {
        [self dealCardToHouse];
    }
}

- (BOOL)houseWins {
    if (self.house.blackjack && self.player.blackjack) {
        return NO; // this is actually a 'push'
    }
    if (self.house.busted) {
        return NO;
    }
    if (self.player.busted) {
        return YES;
    }
    if (self.player.handscore > self.house.handscore) {
        return NO;
    }
    return YES;
}



- (void)incrementWinsAndLossesForHouseWins:(BOOL)houseWins {
    if (houseWins) {
        self.house.wins ++;
        self.player.losses ++;
        //NSLog(@"%@", self.house.description);
    } else {
        self.player.wins ++;
        self.house.losses ++;
        //NSLog(@"%@", self.player.description);
    }
}

@end
