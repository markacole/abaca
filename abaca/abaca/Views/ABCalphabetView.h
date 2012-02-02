//
//  ABCalphabetView.h
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCalphabetButtonView.h"

@protocol ABCalphabetViewDelegate;

@interface ABCalphabetView : UIView <ABCalphabetButtonViewDelegate>{
    BOOL isPlaying;
    BOOL isFinding;
    
    NSArray *alphabet;
    
    NSMutableArray *alphabetButtonViews;
    
    ABCalphabetButtonView *_currentButton;
}


@property (nonatomic,assign) id <ABCalphabetViewDelegate> delegate;
@property (nonatomic,retain) UIButton *homeButton;
@property (nonatomic,retain) UIButton *playButton;
@property (nonatomic,retain) UIButton *findButton;
@property (nonatomic,assign) ABCalphabetButtonView *currentButton;


-(void)homeButtonPressed:(id)sender;
-(void)playButtonPressed:(id)sender;
-(void)findButtonPressed:(id)sender;
-(void)playCancelled;
-(ABCalphabetButtonView *)getButtonWithLetter:(NSString *)letter;
-(void)disableAlphaButtons;
-(void)enableAlphaButtons;

@end


@protocol ABCalphabetViewDelegate <NSObject>

@optional
-(void)alphabetLetterButtonPressedWithLetter:(NSString *)letter;
-(void)homeButtonPressed;
-(BOOL)pausePlayButtonPressedReturnIsPlaying;
-(void)findButtonPressed;

@end