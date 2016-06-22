//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Michael Amundsen on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *houseScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLossesLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseBustedLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseBlackjackLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseStayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseFirstCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseSecondCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseThirdCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseFourthCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseFifthCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLossesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerBustedLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjackLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerStayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFirstCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerSecondCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerThirdCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFourthCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFifthCardLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gameBoardLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *beginNewGameCardLabels;

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;

@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *stayButton;

@property (strong, nonatomic) NSArray *cardLabels;


@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardLabels = @[@[self.playerFirstCardLabel,
                          self.playerSecondCardLabel,
                          self.playerThirdCardLabel,
                          self.playerFourthCardLabel,
                          self.playerFifthCardLabel],
                        @[self.houseFirstCardLabel,
                          self.houseSecondCardLabel,
                          self.houseThirdCardLabel,
                          self.houseFourthCardLabel,
                          self.houseFifthCardLabel]];
    [self resetGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetGame {
    self.game = [[FISBlackjackGame alloc] init];
    [self.game dealNewRound];
    [self resetCardText];
    [self resetGameBoardLabels];
}

- (void)resetGameBoardLabels {
    for (UILabel *boardLabel in self.gameBoardLabels) {
        boardLabel.hidden = YES;
    }
}

- (void)resetCardText {
    for (NSArray *playerCards in self.cardLabels) {
        for (UILabel *cardLabel in playerCards) {
            cardLabel.text = @"";
        }
    }
}

///////////////

- (IBAction)dealTapped:(id)sender {
    [self resetGame];
    [self showNewGameCards];
    [self updatePlayerScore:self.game.player.handscore];
    
    if (self.game.player.blackjack == NO && self.game.house.blackjack == NO) {
        self.hitButton.enabled = YES;
        self.stayButton.enabled = YES;
    } else {
        [self checkForWin];
    }
}

- (void)showNewGameCards {
    self.playerFirstCardLabel.text = [self.game.player.cardsInHand[0] cardLabel];
    self.playerFirstCardLabel.hidden = NO;
    self.playerSecondCardLabel.text = [self.game.player.cardsInHand[1] cardLabel];
    self.playerSecondCardLabel.hidden = NO;
    self.houseFirstCardLabel.text = @"❂";
    self.houseFirstCardLabel.hidden = NO;
    self.houseSecondCardLabel.text = [self.game.house.cardsInHand[1] cardLabel];
    self.houseSecondCardLabel.hidden = NO;
}

////////////////

- (void)updatePlayerScore:(NSUInteger)score {
    self.playerScoreLabel.text = [NSString stringWithFormat:@"%lu", score];
    
}

- (void)updateHouseScore:(NSUInteger)score {
    self.houseScoreLabel.text = [NSString stringWithFormat:@"%lu", score];
    
}

- (void)updateGameLabels {
    
    if (self.game.player.blackjack) {
        self.playerBlackjackLabel.hidden = NO;
    }
    
    if (self.game.house.blackjack) {
        self.houseBlackjackLabel.hidden = NO;
    }
    
    if (self.game.player.busted) {
        self.playerBustedLabel.hidden = NO;
    }
    
    if (self.game.house.busted) {
        self.houseBustedLabel.hidden = NO;
    }
    
    if (self.game.player.stayed) {
        self.playerStayedLabel.hidden = NO;
    }
    
    if (self.game.house.stayed) {
        self.houseStayedLabel.hidden = NO;
    }
}

- (BOOL)checkForWin{
    if (self.game.player.busted || self.game.player.stayed || self.game.house.busted || self.game.house.stayed) {
        [self.game incrementWinsAndLossesForHouseWins:[self.game houseWins]];
        self.playerWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
        self.playerLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.player.losses];
        self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
        self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.house.losses];
        [self updatePlayerScore:self.game.player.handscore];
        [self updateHouseScore:self.game.house.handscore];
        self.houseScoreLabel.hidden = NO;
        if ([self.game houseWins]) {
            self.winLossLabel.text = @"You lost!";
            self.winLossLabel.hidden = NO;
        } else {
            self.winLossLabel.text = @"You win!";
            self.winLossLabel.hidden = NO;
        }
        self.dealButton.enabled = YES;
        return YES;
    }
    return NO;
}

- (void)housePlay {
    //house determines if to play
    if ([self.game processHouseTurn]) {
        [self showDealtCard:[self.game dealCardToHouse] CardLabels:self.cardLabels[1]];
    }
    
    //update house score
    [self updateHouseScore:self.game.house.handscore];
    //check for win or bust
    if (![self checkForWin]) {
        if (self.game.player.stayed) {
            [self.game processHouseTurn];
        }
    }
    [self updateGameLabels];
}

- (IBAction)playerHitTapped:(id)sender {
    //deal card to player and updates board
    [self showDealtCard:[self.game dealCardToPlayer] CardLabels:self.cardLabels[0]];
    
    //update player score
    [self updatePlayerScore:self.game.player.handscore];
    //check for win or bust
    if (![self checkForWin]) {
        [self housePlay];
    } else {
        //update game labels
        [self updateGameLabels];
    }
}

- (IBAction)playerStayTapped:(id)sender {
    self.game.player.stayed = YES;
    self.hitButton.enabled = NO;
    self.stayButton.enabled = NO;
    [self housePlay];
}

- (void)showDealtCard:(FISCard *)card CardLabels:(NSArray *)cardLabels {
    for (UILabel *cardLabel in cardLabels) {
        if ([cardLabel.text length] == 0) {
            cardLabel.text = card.cardLabel;
            cardLabel.hidden = NO;
            break;
        }
    }
}


@end
