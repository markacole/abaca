//
//  ABCalphabetView.m
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCalphabetView.h"

@implementation ABCalphabetView

@synthesize delegate;
@synthesize homeButton;
@synthesize playButton;
@synthesize findButton;
@dynamic currentButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = nil;
        
        self.backgroundColor = [UIColor colorWithRed:1.0 green:150.0/255.0 blue:26.0/255.0 alpha:1.0];
        
        alphabet = [[NSArray alloc] initWithObjects:
                    @"a",
                    @"b",
                    @"c",
                    @"d",
                    @"e",
                    @"f",
                    @"g",
                    @"h",
                    @"i",
                    @"j",
                    @"k",
                    @"l",
                    @"m",
                    @"n",
                    @"o",
                    @"p",
                    @"q",
                    @"r",
                    @"s",
                    @"t",
                    @"u",
                    @"v",
                    @"w",
                    @"x",
                    @"y",
                    @"z",
                    nil];
        
        alphabetButtonViews = [[NSMutableArray alloc] initWithCapacity:26];
    }
    return self;
}



-(void)homeButtonPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(homeButtonPressed)]){
        [self.delegate homeButtonPressed];
    }
}

-(void)playButtonPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(pausePlayButtonPressedReturnIsPlaying)]){
        isPlaying = [self.delegate pausePlayButtonPressedReturnIsPlaying];
        if (isPlaying) {
            [self.playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
            [self.playButton setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
        }else{
            [self.playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
            [self.playButton setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
        }
    }
}

-(void)findButtonPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(findButtonPressed)]) {
        [self.delegate findButtonPressed];
    }
}

-(void)playCancelled{
    isPlaying = NO;
    [self.playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
}

-(void)alphabetButtonBeganPress:(ABCalphabetButtonView *)alphabetButton{
    self.currentButton = alphabetButton;
    [self disableAlphaButtons];
}

-(void)alphabetButtonFinishedPress:(ABCalphabetButtonView *)alphabetButton{
    if ([self.delegate respondsToSelector:@selector(alphabetLetterButtonPressedWithLetter:)]){
        [self.delegate alphabetLetterButtonPressedWithLetter:alphabetButton.letter];
    }
}



-(void)alphabetButtonClosed:(ABCalphabetButtonView *)alphabetButton{
    if (self.currentButton == alphabetButton) {
        self.currentButton = nil;
        [self enableAlphaButtons];
    }
    
}


-(void)alphabetButton:(ABCalphabetButtonView *)alhabetButton wasCorrectSelectionForFind:(BOOL)correctSelectionForFind{
    if ([self.delegate respondsToSelector:@selector(alphabetLetterButtonWasPressedInFindMode:correct:)]){
        [self.delegate alphabetLetterButtonWasPressedInFindMode:alhabetButton correct:correctSelectionForFind];
    }
}



-(void)setCurrentButton:(ABCalphabetButtonView *)currentButton{
    _currentButton = currentButton;
    if (_currentButton){
        [self.currentButton highlight];
    }
    
}

-(ABCalphabetButtonView *)currentButton{
    return _currentButton;
}

-(ABCalphabetButtonView *)getButtonWithLetter:(NSString *)letter{
    ABCalphabetButtonView *retVal = nil;
    for (ABCalphabetButtonView *vw in alphabetButtonViews){
        if ([vw.letter isEqualToString:letter]){
            retVal = vw;
            break;
        }
    }
    return retVal;
}


-(void)disableAlphaButtons{
    for (ABCalphabetButtonView *vw in alphabetButtonViews) {
        vw.userInteractionEnabled = NO;
    }
}

-(void)enableAlphaButtons{
    for (ABCalphabetButtonView *vw in alphabetButtonViews) {
        vw.userInteractionEnabled = YES;
    }
}

-(void)setLetterForFind:(NSString *)letter{
    for (ABCalphabetButtonView *vw in alphabetButtonViews) {
        if ([vw.letter isEqualToString:letter]){
            vw.isLetterForFind = YES;
        }else{
            vw.isLetterForFind = NO;
        }
        vw.isInFindMode = YES;
    }
}


-(void)endFind{
    for (ABCalphabetButtonView *vw in alphabetButtonViews) {
        vw.isLetterForFind = NO;
        vw.isInFindMode = NO;
    }
}



-(void)dealloc{
    [alphabetButtonViews release];
    [alphabet release];
    self.delegate = nil;
    self.homeButton = nil;
    self.playButton = nil;
    self.findButton = nil;
    [super dealloc];
}

@end
