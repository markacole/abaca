//
//  ABCalphabetButtonView.m
//  abaca
//
//  Created by Mark Cole on 01/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCalphabetButtonView.h"

@implementation ABCalphabetButtonView

@dynamic letter;
@synthesize button;
@synthesize delegate;
@synthesize isLetterForFind;
@synthesize isInFindMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isLetterForFind = NO;
        self.isInFindMode = NO;
        
        letterImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [self addSubview:letterImg];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.exclusiveTouch = YES;
        self.button.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.button];
    }
    return self;
}

-(void)setLetter:(NSString *)letter{
    if (_letter != nil){
        [_letter release];
        _letter = nil;
    }
    if (letter != nil) {
        _letter = [letter retain];
        
        NSString *imgName = [NSString stringWithFormat:@"%@/alphButt_%@.png",[[NSBundle mainBundle] resourcePath],letter];
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:imgName];
        letterImg.image = [UIImage imageWithData:imgData];
    }else{
        letterImg.image = nil;
    }
}

-(NSString *)letter{
    return _letter;
}


-(void)buttonPressed:(id)sender{
    if (isInFindMode) {
        if (!isLetterForFind) {
            [self showWrong];
        }
        
        if ([self.delegate respondsToSelector:@selector(alphabetButton:wasCorrectSelectionForFind:)]){
            [self.delegate alphabetButton:self wasCorrectSelectionForFind:isLetterForFind];
        }
    }else{
        buttonPressedByUser = YES;
        if ([self.delegate respondsToSelector:@selector(alphabetButtonBeganPress:)]) {
            [self.delegate alphabetButtonBeganPress:self];
        }
    }
    
}

-(void)highlight{
    CGRect rect = CGRectZero;
    rect.size.width = floorf(self.frame.size.width*1.2);
    rect.size.height = floorf(self.frame.size.height*1.2);
    rect.origin.x = floorf((self.frame.size.width-rect.size.width)/2.0);
    rect.origin.y = floorf((self.frame.size.height-rect.size.height)/2.0);
    
    if (!buttonPressedByUser) {
        if ([self.delegate respondsToSelector:@selector(alphabetButtonBeganHighlightWithoutPress:)]) {
            [self.delegate alphabetButtonBeganHighlightWithoutPress:self];
        }
    }
    
    [UIView animateWithDuration:0.4 animations:^(void){
        letterImg.frame = rect;
    } completion:^(BOOL finished){
        if (buttonPressedByUser) {
            if ([self.delegate respondsToSelector:@selector(alphabetButtonFinishedPress:)]) {
                [self.delegate alphabetButtonFinishedPress:self];
            }
        }
        
    }];
}


-(void)showWrong{
    CGRect rect = CGRectZero;
    rect.size.width = floorf(self.frame.size.width/1.1);
    rect.size.height = floorf(self.frame.size.height/1.1);
    rect.origin.x = floorf((self.frame.size.width-rect.size.width)/2.0);
    rect.origin.y = floorf((self.frame.size.height-rect.size.height)/2.0);
    
    if (!buttonPressedByUser) {
        if ([self.delegate respondsToSelector:@selector(alphabetButtonBeganHighlightWithoutPress:)]) {
            [self.delegate alphabetButtonBeganHighlightWithoutPress:self];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^(void){
        letterImg.frame = rect;
    } completion:^(BOOL finished){
        [self reset];
    }];
}

-(void)reset{
    buttonPressedByUser = NO;
    CGRect rect = CGRectZero;
    rect.size.width = self.frame.size.width;
    rect.size.height = self.frame.size.height;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    
    float animDur = 0.4;
    if (isInFindMode) animDur = 0.2;
    
    [UIView animateWithDuration:animDur animations:^(void){
        letterImg.frame = rect;
    } completion:^(BOOL finished){
        if ([self.delegate respondsToSelector:@selector(alphabetButtonClosed:)]) {
            [self.delegate alphabetButtonClosed:self];
        }
    }];
}

-(void)dealloc{
    [letterImg release];
    self.letter = nil;
    self.button = nil;
    self.delegate = nil;
    [super dealloc];
}

@end
