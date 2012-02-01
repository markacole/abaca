//
//  ABCalphabetView_iPhone.m
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCalphabetView_iPhone.h"

@implementation ABCalphabetView_iPhone

@synthesize scroll;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 44.0, 480.0, 320.0-44.0)];
        self.scroll = scr;
        [scr release];
        [self addSubview:self.scroll];
        
        UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 44.0)];
        [self addSubview:navBar];
        
        UIImageView *navBarBG = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 50.0)];
        navBarBG.image = [UIImage imageNamed:@"AlphabetNavBar_iPhone.png"];
        [navBar addSubview:navBarBG];
        [navBarBG release];
        
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
        [homeBtn setImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
        [homeBtn setImage:[UIImage imageNamed:@"HomeButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:homeBtn];
        self.homeButton = homeBtn;
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(480.0-54.0, 0.0, 44.0, 44.0);
        [playBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [playBtn addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:playBtn];
        self.playButton = playBtn;
        
        UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        findBtn.frame = CGRectMake(240.0-22.0, 0.0, 44.0, 44.0);
        [findBtn setImage:[UIImage imageNamed:@"FindButton.png"] forState:UIControlStateNormal];
        [findBtn setImage:[UIImage imageNamed:@"FindButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [findBtn addTarget:self action:@selector(findButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:findBtn];
        self.findButton = findBtn;
        
        [navBar release];
        
        
        int colCount = 0;
        int rowCount = 0;
        float cellW = 120.0;
        float cellH = 110.0;
        for (int i=0; i<[alphabet count]; i++) {
            if ([[alphabet objectAtIndex:i] isEqualToString:@"y"]) {
                colCount++;
            }
            
            
            ABCalphabetButtonView *but = [[ABCalphabetButtonView alloc] initWithFrame:CGRectMake(colCount*cellW, rowCount*cellH, cellW, cellH)];
            but.tag = 100+i;
            but.delegate = self;
            but.letter = [alphabet objectAtIndex:i];
            [scroll addSubview:but];
            [alphabetButtonViews addObject:but];
            [but release];
            
            
            colCount++;
            if (colCount > 3) {
                colCount = 0;
                rowCount++;
            }
        }
        
        scroll.contentSize = CGSizeMake(480.0, (rowCount+1)*cellH);
        
        
    }
    return self;
}

-(void)alphabetButtonBeganPress:(ABCalphabetButtonView *)alphabetButton{
    [scroll bringSubviewToFront:alphabetButton];
    [scroll scrollRectToVisible:alphabetButton.frame animated:YES];
    [super alphabetButtonBeganPress:alphabetButton];
}

-(void)alphabetButtonBeganHighlightWithoutPress:(ABCalphabetButtonView *)alphabetButton{
    [scroll bringSubviewToFront:alphabetButton];
    
    [scroll scrollRectToVisible:alphabetButton.frame animated:YES];
}

-(void)dealloc{
    self.scroll = nil;
    [super dealloc];
}

@end
