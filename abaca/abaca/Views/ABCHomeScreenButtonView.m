//
//  ABCHomeScreenButtonView.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCHomeScreenButtonView.h"

@implementation ABCHomeScreenButtonView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            btnImg = [[UIImage imageNamed:@"HomeScreenButtons.png"] retain];
            btnImgHighlighted = [[UIImage imageNamed:@"HomeScreenButtons_Highlighted.png"] retain];
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            btnImg = [[UIImage imageNamed:@"HomeScreenButtons@2x.png"] retain];
            btnImgHighlighted = [[UIImage imageNamed:@"HomeScreenButtons_Highlighted@2x.png"] retain];
        }
        
        
        
        bg = [[UIImageView alloc] initWithImage:btnImg];
        bg.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        bg.contentStretch = CGRectMake(0.5,0.5,0.0,0.0);
        [self addSubview:bg];
        
        
        
        float scale = 1.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) scale = 2.0;
        
        textImg = [[UIImageView alloc] initWithFrame:CGRectMake(90.0*scale, (frame.size.height-44.0*scale)/2.0, 200.0*scale, 44.0*scale)];
        [self addSubview:textImg];
        
        
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20.0*scale, (frame.size.height-44.0*scale)/2.0, 44.0*scale, 44.0*scale)];
        [self addSubview:iconImg];
        
        
        btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        btn.exclusiveTouch = YES;
        btn.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDragInside];
        [btn addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchDragOutside];
        [self addSubview:btn];
    }
    return self;
}



-(void)setTextImage:(UIImage *)txtImg{
    textImg.image = txtImg;
}

-(void)setIconImage:(UIImage *)icnImg{
    iconImg.image = icnImg;
}

-(void)buttonPressed:(id)sender{
    bg.image = btnImg;
    if ([self.delegate respondsToSelector:@selector(homeScreenButtonPressed:)]){
        [self.delegate homeScreenButtonPressed:self];
    }
}
-(void)buttonUp:(id)sender{
    bg.image = btnImg;
}
-(void)buttonDown:(id)sender{
    bg.image = btnImgHighlighted;
}


-(void)dealloc{
    [bg release];
    [btnImg release];
    [btnImgHighlighted release];
    [btn release];
    [iconImg release];
    [textImg release];
    [super dealloc];
}

@end
