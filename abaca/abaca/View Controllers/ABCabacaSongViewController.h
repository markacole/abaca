//
//  ABCabacaSongViewController.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ABCabacaSong.h"
#import "ABCabacaSongView.h"

@interface ABCabacaSongViewController : ABCBaseViewController<AVAudioPlayerDelegate>{
    ABCabacaSong *song;
    AVAudioPlayer *audioPlayer;
    
    UIButton *pauseBtn;
    
    NSMutableArray *alphaViews;
    
    NSInteger currentPage;
    
    UIView *songViewContainer;
    
    NSArray *alphabet;
    NSArray *times;
    
    BOOL musicEnded;
}

@property (nonatomic,retain) NSTimer *songProgressTimer;

@end
