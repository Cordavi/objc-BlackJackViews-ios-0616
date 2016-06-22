//
//  FISBlackjackGame.m
//  BlackJack
//
//  Created by Michael Amundsen on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"
#import "FISCard.h"

@interface FISBlackjackGame ()
@property (nonatomic) NSUserDefaults *defaults;
@end

@implementation FISBlackjackGame

- (instancetype)init {
    self = [super init];
    if (self) {
        _deck = [[FISCardDeck alloc] init];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House" Wins:[self.defaults integerForKey:@"HouseWins"] Losses:[self.defaults integerForKey:@"HouseLosses"]];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player" Wins:[self.defaults integerForKey:@"PlayerWins"] Losses:[self.defaults integerForKey:@"PlayerLosses"]];
    }
    return self;
}

- (void)setWinsLossesDefaults {
    [self.defaults setInteger:self.player.wins forKey:@"PlayerWins"];
    [self.defaults setInteger:self.player.losses forKey:@"PlayerLosses"];
    [self.defaults setInteger:self.house.wins forKey:@"HouseWins"];
    [self.defaults setInteger:self.house.losses forKey:@"HouseLosses"];
    [self.defaults synchronize];
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

- (FISCard *)dealCardToPlayer {
    FISCard *cardDealt = [self.deck drawNextCard];
    [self.player acceptCard:cardDealt];
    return cardDealt;
    
}

- (FISCard *)dealCardToHouse {
    FISCard *cardDealt = [self.deck drawNextCard];
    [self.house acceptCard:cardDealt];
    return cardDealt;
    
}

- (void)processPlayerTurn {
    if ([self.player shouldHit] && !(self.player.stayed) && !(self.player.busted)) {
        [self dealCardToPlayer];
    }
}

- (BOOL)processHouseTurn {
    if ([self.house shouldHit] && !(self.house.stayed) && !(self.house.busted)) {
        return YES;
    }
    return NO;
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
