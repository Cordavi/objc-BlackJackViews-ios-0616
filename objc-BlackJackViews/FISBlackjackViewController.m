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

@property (weak, nonatomic) IBOutlet UILabel *playerStayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLossesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerBustedLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjackLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFirstCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerSecondCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerThirdCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFourthCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFifthCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;

@property (strong, nonatomic) NSArray *playerCardLabels;
@property (strong, nonatomic) NSArray *houseCardLabels;

@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *stayButton;

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetLabels];
    [self resetGame];
}

- (void)resetGame {
    self.playerCardLabels = @[self.playerFirstCardLabel,
                              self.playerSecondCardLabel,
                              self.playerThirdCardLabel,
                              self.playerFourthCardLabel,
                              self.playerFifthCardLabel];
    
    self.houseCardLabels = @[self.houseFirstCardLabel,
                             self.houseSecondCardLabel,
                             self.houseThirdCardLabel,
                             self.houseFourthCardLabel,
                             self.houseFifthCardLabel];
    
    [self hideShowCardLabels:self.playerCardLabels];
    [self hideShowCardLabels:self.houseCardLabels];
    
    self.houseBustedLabel.hidden = YES;
    self.houseStayedLabel.hidden = YES;
    self.houseBlackjackLabel.hidden = YES;
    self.playerBustedLabel.hidden = YES;
    self.playerStayedLabel.hidden = YES;
    self.playerBlackjackLabel.hidden = YES;
    self.winLossLabel.hidden = YES;
    self.houseScoreLabel.hidden = YES;
}

-(void)resetLabels {
    for (UILabel *cardLabel in self.playerCardLabels) {
        cardLabel.text = @"";
    }
    for (UILabel *cardLabel in self.houseCardLabels) {
        cardLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideShowCardLabels:(NSArray *)cardLabels {
    for (UILabel *cardLabel in cardLabels) {
        if (!([cardLabel.text length] == 0)) {
            cardLabel.hidden = NO;
        } else {
            cardLabel.hidden = YES;
        }
    }
}

- (void)setCardLabelsWithCards:(FISBlackjackPlayer *)player CardLabels:(NSArray *)cardLabels  {
    for (FISCard *card in player.cardsInHand) {
        for (UILabel *cardLabelToSet in cardLabels) {
            if ([card.cardLabel isEqualToString:cardLabelToSet.text]) {
                break;
            }
            if ([cardLabelToSet.text length] == 0) {
                cardLabelToSet.text = card.cardLabel;
                break;
            }
        }
    }
    [self hideShowCardLabels:cardLabels];
    
}

- (IBAction)dealTapped:(id)sender {
    [self resetGame];
    [self resetLabels];
    self.game = [[FISBlackjackGame alloc] init];
    [self.game dealNewRound];
    [self setCardLabelsWithCards:self.game.player CardLabels:self.playerCardLabels];
    [self setCardLabelsWithCards:self.game.house CardLabels:self.houseCardLabels];
    if ([self.game houseWins]) {
        [self checkForWin];
    }
    self.hitButton.enabled = YES;
    self.stayButton.enabled = YES;
    [self updatePlayerScore:self.game.player.handscore];
}

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
    [self.game processHouseTurn];
    //update cards show on board
    [self setCardLabelsWithCards:self.game.house CardLabels:self.houseCardLabels];
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
    //deal card to player
    [self.game dealCardToPlayer];
    //update cards shown on board
    [self setCardLabelsWithCards:self.game.player CardLabels:self.playerCardLabels];
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


@end
