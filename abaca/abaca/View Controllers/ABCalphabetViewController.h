//
//  ABCalphabetViewController.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ABCalphabetView_iPhone.h"
#import "ABCalphabetView_iPad.h"


typedef enum{
    ABCalphabetViewModeNormal,
    ABCalphabetViewModePlay,
    ABCalphabetViewModeEye
}ABCalphabetViewMode;

@interface ABCalphabetViewController : ABCBaseViewController <ABCalphabetViewDelegate,AVAudioPlayerDelegate>{
    NSInteger playModeCurrentIndex;
}

@property (nonatomic) ABCalphabetViewMode viewMode;
@property (nonatomic, retain) ABCalphabetView *alphabetView;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSArray *playModeLettersOrder;
@property (nonatomic, retain) NSTimer *playModeGapTimer;

@end
