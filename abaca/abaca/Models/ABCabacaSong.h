//
//  ABCabacaSong.h
//  abaca
//
//  Created by Mark Cole on 31/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ABCabacaSong : NSObject<AVAudioSessionDelegate>{
    AVAudioSession *session;
    AudioComponentDescription ioUnitDesc;
    AudioComponentDescription speedUnitDesc;
    AUGraph processingGraph;
    AUNode ioNode;
    AUNode speedNode;
    AudioUnit ioUnit;
    AudioUnit speedUnit;
}

@property (nonatomic) float graphSampleRate;


-(void)startGraph;
-(void)stopGraph;
-(void)changePitch:(float)pitch;

@end
