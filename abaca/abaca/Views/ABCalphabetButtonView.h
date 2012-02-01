//
//  ABCalphabetButtonView.h
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCalphabetButtonViewDelegate;


@interface ABCalphabetButtonView : UIView{

    UIImageView *letterImg;
    
    NSString *_letter;
    BOOL buttonPressedByUser;
}

@property (nonatomic,assign) id <ABCalphabetButtonViewDelegate> delegate;
@property (nonatomic,retain) NSString *letter;
@property (nonatomic,retain) UIButton *button;

-(void)highlight;
-(void)reset;

@end



@protocol ABCalphabetButtonViewDelegate <NSObject>

@optional
-(void)alphabetButtonBeganPress:(ABCalphabetButtonView *)alphabetButton;
-(void)alphabetButtonFinishedPress:(ABCalphabetButtonView *)alphabetButton;
-(void)alphabetButtonBeganHighlightWithoutPress:(ABCalphabetButtonView *)alphabetButton;
-(void)alphabetButtonClosed:(ABCalphabetButtonView *)alphabetButton;

@end