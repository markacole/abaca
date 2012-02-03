//
//  ABCReadingWordsView.h
//  abaca
//
//  Created by Mark Cole on 02/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ABCReadingWordsViewDelegate;

typedef enum{
    ReadingStateEntry,
    ReadingStateNone,
    ReadingStateInitialised,
    ReadingStateShowingHandWord,
    ReadingStateShowingHandSentence,
    ReadingStatePlayingWord,
    ReadingStatePlayingSentence,
    ReadingStateShowingImage,
    ReadingStateEndWord,
    ReadingStateEndSentence,
    ReadingStatePlayingWordByUserTouch
}ReadingState;

@interface ABCReadingWordsView : UIView <AVAudioPlayerDelegate>{
    UIImageView *hand;
    UIImageView *words;
    
    BOOL isiPad;
    
    NSDictionary *pointerList;
    
    ReadingState readingState;
    
    NSInteger word0letterIndex;
    NSInteger sentenceWordIndex;
    
    float wordPlayStart;
    float wordPlayEnd;
}

@property (nonatomic, assign) id <ABCReadingWordsViewDelegate> delegate;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSTimer *gapTimer;
@property (nonatomic, retain) NSTimer *audioTimer;
@property (nonatomic) NSInteger sentenceIndex;
@property (nonatomic) NSInteger word0Index;

-(void)startWordsWithIndex:(NSInteger)index;
-(void)stop;

@end



@protocol ABCReadingWordsViewDelegate <NSObject>

@optional
-(void)readingWordsViewDidChangeSentenceIndex:(ABCReadingWordsView *)readingWordsView;
-(void)readingWordsViewShowImage;
-(void)readingWordsViewHideImage;

@end
