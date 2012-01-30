//
//  ABCRootViewController.h
//  abaca
//
//  Created by Mark Cole on 29/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCHomeScreenButtonView.h"
#import <AVFoundation/AVFoundation.h>

@interface ABCRootViewController : UIViewController <ABCHomeScreenButtonViewDelegate>{
    AVAudioPlayer *audioPlayer;
}

@end
