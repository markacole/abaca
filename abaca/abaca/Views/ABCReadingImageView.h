//
//  ABCReadingImageView.h
//  abaca
//
//  Created by Mark Cole on 02/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ABCReadingImageView : UIView<AVAudioPlayerDelegate>{
    UIImageView *imgVw;
    
    NSInteger currentImageIndex;
}

@property (nonatomic, retain) AVAudioPlayer *player;

-(void)showImageAtIndex:(NSInteger)index;
-(void)hideImage;

@end
