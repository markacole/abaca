//
//  ABCyapYapSongViewController.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ABCyapYapSongViewController : ABCBaseViewController<AVAudioPlayerDelegate>{
    UIImageView *line1;
    UIImageView *line2;
    UIImageView *line3;
    
    UIImageView *hand;
    
    NSInteger currentLine;
    NSInteger currentWord;
    NSInteger currentVerse;
    
    UIButton *pauseBtn;
    
    BOOL isiPad;
    
    NSDictionary *pointerList;
    
    float scale;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSTimer *timer;


-(void)stopSound;

@end
