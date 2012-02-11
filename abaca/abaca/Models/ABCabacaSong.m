//
//  ABCabacaSong.m
//  abaca
//
//  Created by Mark Cole on 31/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCabacaSong.h"

@interface ABCabacaSong (hidden){
    
}


-(void)loadMP3;
-(void)setupSession;
-(void)specifyAudioUnits;
-(void)createGraph;
-(void)configureAudioUnits;
-(void)connectTheNodes;

@end


@implementation ABCabacaSong

OSStatus speedCallback(void *inRefCon,AudioUnitRenderActionFlags *ioActionFlags,const AudioTimeStamp *inTimeStamp,UInt32 inBusNumber,UInt32 inNumberFrames,AudioBufferList * ioData);

@synthesize graphSampleRate;

-(id)init{
    self = [super init];
    if (self) {
        [self loadMP3];
        [self setupSession];
        [self specifyAudioUnits];
        [self createGraph];
        [self configureAudioUnits];
        [self connectTheNodes];
    }
    return self;
}



-(void)loadMP3{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/a_apple_mix_2_FINAL.mp3", [[NSBundle mainBundle] resourcePath]]];
    AudioFileID inAudioFile = NULL;
    
    
    OSStatus status;
    //OSStatus close_status;
    
#ifndef TARGET_OS_IPHONE
	// This constant is missing under Mac OS X
# define kAudioFileReadPermission fsRdPerm
#endif
	
#define BUFFER_SIZE 4096
	//char *buffer = NULL;
    
    status = AudioFileOpenURL((CFURLRef)url, kAudioFileReadPermission, 0, &inAudioFile);
    if (status)
	{
		//goto reterr;
	}
    
    
    
    

}


-(void)setupSession{
    self.graphSampleRate = 44100.0;
    session = [AVAudioSession sharedInstance];
    session.delegate = self;
    NSError *err = nil;
    [session setPreferredHardwareSampleRate:self.graphSampleRate error:&err];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:&err];
    [session setActive:YES error:&err];
    self.graphSampleRate = [session currentHardwareSampleRate];
}







-(void)specifyAudioUnits{
    
    ioUnitDesc.componentType            = kAudioUnitType_Output;
    ioUnitDesc.componentSubType         = kAudioUnitSubType_RemoteIO;
    ioUnitDesc.componentManufacturer    = kAudioUnitManufacturer_Apple;
    ioUnitDesc.componentFlags           = 0;
    ioUnitDesc.componentFlagsMask       = 0;
    
    
    speedUnitDesc.componentType            = kAudioUnitType_FormatConverter;
    speedUnitDesc.componentSubType         = kAudioUnitSubType_Varispeed;
    speedUnitDesc.componentManufacturer    = kAudioUnitManufacturer_Apple;
    speedUnitDesc.componentFlags           = 0;
    speedUnitDesc.componentFlagsMask       = 0;
}








-(void)createGraph{
    NewAUGraph(&processingGraph);
    
    AUGraphAddNode(processingGraph, &ioUnitDesc, &ioNode);
    AUGraphAddNode(processingGraph, &speedUnitDesc, &speedNode);
    
    AUGraphOpen(processingGraph);
    
    AUGraphNodeInfo(processingGraph, ioNode, NULL, &ioUnit);
    AUGraphNodeInfo(processingGraph, speedNode, NULL, &speedUnit);
}







-(void)configureAudioUnits{
    int bytesPerSample = sizeof(AudioUnitSampleType);
    AudioStreamBasicDescription stereoInputStreamFormat = {0};
    stereoInputStreamFormat.mFormatID = kAudioFormatMPEGLayer3;
    stereoInputStreamFormat.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    stereoInputStreamFormat.mBytesPerPacket = bytesPerSample;
    stereoInputStreamFormat.mBytesPerFrame = bytesPerSample;
    stereoInputStreamFormat.mFramesPerPacket = 1;
    stereoInputStreamFormat.mBitsPerChannel = 8*bytesPerSample;
    stereoInputStreamFormat.mChannelsPerFrame  = 1;
    stereoInputStreamFormat.mSampleRate = self.graphSampleRate;
    
    //INPUT
    UInt32 inputBusCount = 1;
    AudioUnitSetProperty(speedUnit, 
                         kAudioUnitProperty_ElementCount, 
                         kAudioUnitScope_Input, 
                         0, 
                         &inputBusCount, 
                         sizeof(inputBusCount));
    
    
    AudioUnitElement speedAudioBus = 0;
    AudioUnitSetProperty(speedUnit, 
                         kAudioUnitProperty_StreamFormat, 
                         kAudioUnitScope_Input, 
                         speedAudioBus, 
                         &stereoInputStreamFormat, 
                         sizeof(stereoInputStreamFormat));
    
    
    //OUTPUT
    AudioUnitSetProperty(speedUnit, 
                         kAudioUnitProperty_SampleRate, 
                         kAudioUnitScope_Output, 
                         0, 
                         &graphSampleRate, 
                         sizeof(graphSampleRate));
    
    
    
    
    AURenderCallbackStruct speedCallbackStruct;
    speedCallbackStruct.inputProc = &speedCallback;
    speedCallbackStruct.inputProcRefCon = self;
    
    AUGraphSetNodeInputCallback(processingGraph, speedNode, speedAudioBus, &speedCallbackStruct);
    
    
}






-(void)connectTheNodes{
    AUGraphConnectNodeInput(processingGraph, ioNode, 1, speedNode, 0);
    AUGraphConnectNodeInput(processingGraph, speedNode, 0, ioNode, 0);
    
}


OSStatus speedCallback(void *inRefCon,AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList * ioData)
{
	OSStatus err = noErr; // just a formality at this point.
	
	//memcpy( theBufferList->mBuffers[0].mData,&ioData->mBuffers[0].mData, ioData->mBuffers[0].mDataByteSize);		
    
	return err;
}



-(void)startGraph{
    AUGraphInitialize(processingGraph);
    AUGraphStart(processingGraph);
}

-(void)stopGraph{
    AUGraphStop(processingGraph);
}

-(void)changePitch:(float)pitch{
    AudioUnitParameterValue newPitch = (AudioUnitParameterValue) pitch;
    AudioUnitSetParameter(speedUnit, kVarispeedParam_PlaybackRate, kAudioUnitScope_Input, 0, newPitch, 0);
}




@end
