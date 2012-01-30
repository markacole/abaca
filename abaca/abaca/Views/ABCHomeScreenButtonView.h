//
//  ABCHomeScreenButtonView.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCHomeScreenButtonViewDelegate;

@interface ABCHomeScreenButtonView : UIView{
    UIImageView *textImg;
    UIImageView *iconImg;
    
    UIImageView *bg;
    UIImage *btnImg;
    UIImage *btnImgHighlighted;
    
    UIButton *btn;
}

@property (nonatomic,assign) id <ABCHomeScreenButtonViewDelegate> delegate;

-(void)setTextImage:(UIImage *)txtImg;
-(void)setIconImage:(UIImage *)icnImg;

@end


@protocol ABCHomeScreenButtonViewDelegate <NSObject>

@optional
-(void)homeScreenButtonPressed:(ABCHomeScreenButtonView *)buttonView;

@end