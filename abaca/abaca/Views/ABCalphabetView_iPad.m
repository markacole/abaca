//
//  ABCalphabetView_iPad.m
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCalphabetView_iPad.h"

@implementation ABCalphabetView_iPad



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame = CGRectMake(32.0, 20.0, 108.0, 108.0);
        [homeBtn setImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
        [homeBtn setImage:[UIImage imageNamed:@"HomeButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeBtn];
        self.homeButton = homeBtn;
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(1024.0-32.0-108.0, 20.0, 108.0, 108.0);
        [playBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [playBtn addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
        self.playButton = playBtn;
        
        UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        findBtn.frame = CGRectMake(1024.0-32.0-108.0, 768.0-20.0-108.0, 108.0, 108.0);
        [findBtn setImage:[UIImage imageNamed:@"FindButton.png"] forState:UIControlStateNormal];
        [findBtn setImage:[UIImage imageNamed:@"FindButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [findBtn addTarget:self action:@selector(findButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:findBtn];
        self.findButton = findBtn;
        
        
        int colCount = 0;
        int rowCount = 0;
        float cellW = 170.0;
        float cellH = 153.0;
        float viewW = floorf(260.0/240.0*cellH);
        float viewX = floorf((cellW-viewW)/2.0);
        
        for (int i=0; i<[alphabet count]; i++) {
            if ([[alphabet objectAtIndex:i] isEqualToString:@"a"] ||
                [[alphabet objectAtIndex:i] isEqualToString:@"e"] ||
                [[alphabet objectAtIndex:i] isEqualToString:@"w"]) {
                colCount++;
                if (colCount > 5) {
                    colCount = 0;
                    rowCount++;
                }
            }
            
            
            ABCalphabetButtonView *but = [[ABCalphabetButtonView alloc] initWithFrame:CGRectMake(colCount*cellW+viewX, rowCount*cellH, viewW, cellH)];
            but.tag = 100+i;
            but.delegate = self;
            but.letter = [alphabet objectAtIndex:i];
            [self insertSubview:but atIndex:0];
            [alphabetButtonViews addObject:but];
            [but release];
            
            
            colCount++;
            if (colCount > 5) {
                colCount = 0;
                rowCount++;
            }
        }
        
        
    }
    return self;
}

-(void)alphabetButtonBeganPress:(ABCalphabetButtonView *)alphabetButton{
    [self bringSubviewToFront:alphabetButton];
    [super alphabetButtonBeganPress:alphabetButton];
}


-(void)alphabetButtonBeganHighlightWithoutPress:(ABCalphabetButtonView *)alphabetButton{
    [self bringSubviewToFront:alphabetButton];
}


@end
