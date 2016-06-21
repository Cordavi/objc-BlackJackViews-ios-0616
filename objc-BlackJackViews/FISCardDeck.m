//
//  FISCardDeck.m
//  OOP-Cards-Model
//
//  Created by Michael Amundsen on 6/15/16.
//  Copyright © 2016 Al Tyus. All rights reserved.
//

#import "FISCardDeck.h"

@implementation FISCardDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        _remainingCards = [@[] mutableCopy];
        _dealtCards = [@[] mutableCopy];
        [self generateCardDeck];
    }
    return self;
}

- (FISCard *)drawNextCard {
    
    if (self.remainingCards.count == 0) {
        NSLog(@"You cannot draw from an empty deck.");
        return nil;
    }
    
    FISCard *drawnCard = self.remainingCards[0];
    [self.dealtCards addObject:drawnCard];
    [self.remainingCards removeObjectAtIndex:0];
    
    return drawnCard;
}

- (void)resetDeck {
    [self gatherDealtCards];
    [self shuffleRemainingCards];
    
}

- (void)gatherDealtCards {
    [self.remainingCards addObjectsFromArray:self.dealtCards];
    [self.dealtCards removeAllObjects];
}

- (void)shuffleRemainingCards {
    NSMutableArray *cardsCopy = [self.remainingCards mutableCopy];
    [self.remainingCards removeAllObjects];
    
    NSUInteger total = cardsCopy.count;
    
    for (NSUInteger i = 0; i < total; i++) {
        NSUInteger cardsCount = cardsCopy.count;
        NSUInteger randomIndex = arc4random_uniform((unsigned int)cardsCount);
        
        FISCard *randomCard = cardsCopy[randomIndex];
        [cardsCopy removeObjectAtIndex:randomIndex];
        [self.remainingCards addObject:randomCard];
    }
}

- (void)generateCardDeck {
        for (NSString *suit in [FISCard validSuits]) {
        for (NSString *rank in [FISCard validRanks]) {
            FISCard *cardToAdd = [[FISCard alloc] initWithSuit:suit rank:rank];
            [self.remainingCards addObject:cardToAdd];
        }
    }
    
}

- (NSString *)description {
    NSString *cardCount = [NSString stringWithFormat:@"%lu", [self.remainingCards count]];
    NSMutableString *cardDeckDescription = [@"" mutableCopy];
    for (FISCard *cardInDeck in self.remainingCards) {
        [cardDeckDescription appendString:[NSString stringWithFormat:@"%@ ", cardInDeck]];
    }
    return [NSString stringWithFormat:@"count: %@\ncards: %@", cardCount, cardDeckDescription];
}

@end
