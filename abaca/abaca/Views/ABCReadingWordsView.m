//
//  ABCReadingWordsView.m
//  abaca
//
//  Created by Mark Cole on 02/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCReadingWordsView.h"

@interface ABCReadingWordsView (hidden)

-(void)playSoundForIndex:(NSInteger)index;
-(void)playSoundForIndex0_wordIndex:(NSInteger)wordIndex;
-(void)playsoundForCurrentSentenceForWordAtPosition:(float)xPos;
-(void)stopSound;
-(void)stopTimer:(NSTimer *)timer;
-(void)startAudioTimer;
-(void)gapTimerFired;
-(void)audioTimerFired;
-(void)startWordsAtIndex0;
-(void)showHand;
-(void)hideHand;
-(void)moveHandToPosition:(float)xPos animated:(BOOL)animated;
-(void)loadPointerList;

@end





@implementation ABCReadingWordsView

@synthesize player;
@synthesize gapTimer;
@synthesize audioTimer;
@synthesize sentenceIndex;
@synthesize word0Index;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadPointerList];
        
        isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad); 
        
        words = [[UIImageView alloc] initWithFrame:CGRectZero];
        words.backgroundColor = [UIColor clearColor];
        if (isiPad) words.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 70.0);
        else words.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 35.0);
        [self addSubview:words];
        words.alpha = 0.0;
        
        
        hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand.png"]];
        if (isiPad) hand.frame = CGRectMake(0.0, 70.0, hand.frame.size.width, hand.frame.size.height);
        else hand.frame = CGRectMake(0.0, 35.0, hand.frame.size.width/2.0, hand.frame.size.height/2.0);
        [self addSubview:hand];
        hand.alpha = 0.0;
        
        
        readingState = ReadingStateEntry;
        
        
    }
    return self;
}


-(void)loadPointerList{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ReadingPointerList" ofType:@"plist"];
    pointerList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}


-(void)startWordsWithIndex:(NSInteger)index{
    [self stopSound];
    [self stopTimer:self.gapTimer];
    [self stopTimer:self.audioTimer];
    [self hideHand];
    
    readingState = ReadingStateInitialised;
    
    if ([self.delegate respondsToSelector:@selector(readingWordsViewDidChangeSentenceIndex:)]){
        [self.delegate readingWordsViewDidChangeSentenceIndex:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(readingWordsViewHideImage)]){
        [self.delegate readingWordsViewHideImage];
    }
    
    if (words.image) {
        [UIView animateWithDuration:0.3 animations:^(void){
            words.alpha = 0.0;
        } completion:^(BOOL finished){
            words.image = nil;
            [self startWordsWithIndex:index];
        }];
    }else{
        self.sentenceIndex = index;
        if (index != 0) {
            NSString *imgName = [NSString stringWithFormat:@"words_%i.png",index];
            words.image = [UIImage imageNamed:imgName];
            words.alpha = 0.0;
        }else{
            self.word0Index = 0;
            words.image = [UIImage imageNamed:@"words_0_rat.png"];
            words.alpha = 0.0;
        }
        
        [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^(void){
            words.alpha = 1.0;
        } completion:^(BOOL finished){
            self.gapTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gapTimerFired) userInfo:nil repeats:NO];
        }];
        
        
    }
    
}


-(void)startWordsAtIndex0{
    [self stopSound];
    [self stopTimer:self.gapTimer];
    [self stopTimer:self.audioTimer];
    
    readingState = ReadingStateInitialised;
    
    if (words.image) {
        [UIView animateWithDuration:0.3 animations:^(void){
            words.alpha = 0.0;
        } completion:^(BOOL finished){
            words.image = nil;
            [self startWordsAtIndex0];
        }];
    }else{
        
        switch (self.word0Index) {
            case 0:
                words.image = [UIImage imageNamed:@"words_0_rat.png"]; 
                break;
            case 1:
                words.image = [UIImage imageNamed:@"words_0_sat.png"];
                break;
            case 2:
                words.image = [UIImage imageNamed:@"words_0_on.png"];
                break;
            case 3:
                words.image = [UIImage imageNamed:@"words_0_cat.png"];
                break;
            default:
                words.image = [UIImage imageNamed:@"words_0.png"];
                break;
        }
        
        
        words.alpha = 0.0;
        
        
        
        [UIView animateWithDuration:0.3 animations:^(void){
            words.alpha = 1.0;
        } completion:^(BOOL finished){
            self.gapTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gapTimerFired) userInfo:nil repeats:NO];
        }];
        
        
    }
}


-(void)playSoundForIndex:(NSInteger)index{
    [self stopSound];
    [self stopTimer:self.audioTimer];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wordsSpoken_%i.mp3", [[NSBundle mainBundle] resourcePath],index]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    self.player.enableRate = YES;
    [self.player play];
    
    [self startAudioTimer];
}

-(void)playSoundForIndex0_wordIndex:(NSInteger)wordIndex{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wordsSpoken_0_%i.mp3", [[NSBundle mainBundle] resourcePath],wordIndex]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    self.player.enableRate = YES;
    [self.player play];
    
    [self startAudioTimer];
}


-(void)playsoundForCurrentSentenceForWordAtPosition:(float)xPos{
    
    //find which word is being pressed (if any)
    NSArray *wordList = [[pointerList objectForKey:@"Sentences"] objectAtIndex:sentenceIndex];
    int closest = -1;
    float currentClosestDiff = 10000;
    for (int i=0; i < [wordList count]; i++){
        NSDictionary *thisWord = [wordList objectAtIndex:i];
        float wordXcenter = [[thisWord objectForKey:@"pos"] floatValue];
        if (!isiPad) wordXcenter = wordXcenter/2.0;
        float difference = fabsf(xPos-wordXcenter);
        if (difference < currentClosestDiff) {
            if (difference < 120.0) {
                currentClosestDiff = difference;
                closest = i;
                
            }
        }
    }
    
    if (closest > -1) {
        NSDictionary *thisWord = [wordList objectAtIndex:closest];
        wordPlayStart = [[thisWord objectForKey:@"time"] floatValue];
        if ((closest+1) < [wordList count]) {
            NSDictionary *nextWord = [wordList objectAtIndex:closest+1];
            wordPlayEnd = [[nextWord objectForKey:@"time"] floatValue];
        }else{
            wordPlayEnd = 60.0;
        }
        
        printf("word %i is closest",closest);
        
        
        
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wordsSpoken_%i.mp3", [[NSBundle mainBundle] resourcePath],sentenceIndex]];
        
        NSError *error = nil;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player = audioPlayer;
        [audioPlayer release];
        self.player.numberOfLoops = 0;
        self.player.volume = 1.0;
        self.player.delegate = self;
        self.player.enableRate = YES;
        self.player.currentTime = wordPlayStart;
        [self.player play];
        
        [self startAudioTimer];
    }else{
        readingState = ReadingStateNone;
    }
    
}


-(void)stopSound{
    if (self.player) {
        if (self.player.isPlaying) {
            [self.player stop];
        }
        self.player = nil;
    }
    
}


-(void)startAudioTimer{
    [self stopTimer:self.audioTimer];
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(audioTimerFired) userInfo:nil repeats:YES];
}

-(void)startGapTimerWithInterval:(float)interval{
    self.gapTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(gapTimerFired) userInfo:nil repeats:NO];
}

-(void)stopTimer:(NSTimer *)timer{
    if (timer != nil){
        if (timer.isValid){
            [timer invalidate];
        }
        if (timer == self.gapTimer) {
            self.gapTimer = nil;
        }else if (timer == self.audioTimer){
            self.audioTimer = nil;
        }
    }
    
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopTimer:self.audioTimer];
    [self gapTimerFired];
    
}



-(void)gapTimerFired{
    self.gapTimer = nil;
    if (readingState == ReadingStateInitialised) {
        
        
        if (self.sentenceIndex != 0) {
            sentenceWordIndex = 0;
            readingState = ReadingStateShowingHandSentence;
        }else{
            if (self.word0Index < 4){
                word0letterIndex = 0;
                readingState = ReadingStateShowingHandWord;
            }else{
                sentenceWordIndex = 0;
                readingState = ReadingStateShowingHandSentence;
                
            }
        }
        [self showHand];
        [self startGapTimerWithInterval:1.0];
        
    }else if (readingState == ReadingStateShowingHandWord){
        
        
        readingState = ReadingStatePlayingWord;
        [self playSoundForIndex0_wordIndex:self.word0Index];
        
        
    }else if (readingState == ReadingStateShowingHandSentence){
        
        
        readingState = ReadingStatePlayingSentence;
        [self playSoundForIndex:self.sentenceIndex];
        
        
    }else if (readingState == ReadingStatePlayingWord){
        
        [self hideHand];
        readingState = ReadingStateEndWord;
        [self startGapTimerWithInterval:0.1];
        
        
    }else if (readingState == ReadingStateEndWord){
        
        
        self.word0Index++;
        if (self.word0Index < 5) {
            [self startWordsAtIndex0];
        }else{
            self.word0Index = 0;
            self.sentenceIndex++;
            [self startWordsWithIndex:self.sentenceIndex];
        }
        
        
    }else if (readingState == ReadingStatePlayingSentence){
        
        [self hideHand];
        readingState = ReadingStateEndSentence;
        [self startGapTimerWithInterval:1.0];
        
        
    }else if (readingState == ReadingStateEndSentence){
        
        
        readingState = ReadingStateShowingImage;
        //show image;
        if ([self.delegate respondsToSelector:@selector(readingWordsViewShowImage)]){
            [self.delegate readingWordsViewShowImage];
        }
        
        [self startGapTimerWithInterval:6.0];
        
        
    }else if (readingState == ReadingStateShowingImage){
        
        readingState = ReadingStateNone;
        
    }else if (readingState == ReadingStatePlayingWordByUserTouch){
        readingState = ReadingStateNone;
    }
    
}

-(void)audioTimerFired{
    printf(".");
    float currentTime = player.currentTime;
    if (readingState == ReadingStatePlayingWord){
        NSArray *letterList = [[pointerList objectForKey:@"Words"] objectAtIndex:word0Index];
        if (word0letterIndex < [letterList count]) {
            
            NSDictionary *thisLetter = [letterList objectAtIndex:word0letterIndex];
            float time = [[thisLetter objectForKey:@"time"] floatValue];
            if (currentTime >= time) {
                if (word0letterIndex == [letterList count]-1) {
                    [self hideHand];
                }else{
                    float pos = [[thisLetter objectForKey:@"pos"] floatValue];
                    [self moveHandToPosition:pos animated:(word0letterIndex != 0)];
                    word0letterIndex++;
                }
            }
            
        }
        
    }else if (readingState == ReadingStatePlayingSentence){
        NSArray *wordList = [[pointerList objectForKey:@"Sentences"] objectAtIndex:sentenceIndex];
        if (sentenceWordIndex < [wordList count]) {
            NSDictionary *thisWord = [wordList objectAtIndex:sentenceWordIndex];
            float time = [[thisWord objectForKey:@"time"] floatValue];
            if (currentTime >= time) {
                float pos = [[thisWord objectForKey:@"pos"] floatValue];
                [self moveHandToPosition:pos animated:YES];
                sentenceWordIndex++;
            }
        }
        
    }else if (readingState == ReadingStatePlayingWordByUserTouch){
        if (currentTime >= wordPlayEnd) {
            readingState = ReadingStateNone;
            [self stopSound];
        }
    }
}

-(void)stop{
    [self stopSound];
    [self stopTimer:self.gapTimer];
    [self stopTimer:self.audioTimer];
}


-(void)showHand{
    float Xpos;
    
    if (readingState == ReadingStateShowingHandWord){
        NSArray *letterList = [[pointerList objectForKey:@"Words"] objectAtIndex:word0Index];
        NSDictionary *thisLetter = [letterList objectAtIndex:0];
        Xpos = [[thisLetter objectForKey:@"pos"] floatValue];
    }else if (readingState == ReadingStateShowingHandSentence){
        NSArray *wordList = [[pointerList objectForKey:@"Sentences"] objectAtIndex:sentenceIndex];
        NSDictionary *thisWord = [wordList objectAtIndex:0];
        Xpos = [[thisWord objectForKey:@"pos"] floatValue];
    }
    
    //if (!isiPad) Xpos = Xpos/2.0;
    
    [self moveHandToPosition:Xpos animated:NO];
    
    [UIView animateWithDuration:0.3 animations:^(void){
        hand.alpha = 1.0;
    }];
}

-(void)hideHand{
    [UIView animateWithDuration:0.3 animations:^(void){
        hand.alpha = 0.0;
    }];
}

-(void)moveHandToPosition:(float)xPos animated:(BOOL)animated{
    
    float minYpos = 70.0;
    float maxYpos = 70.0;
    if (!isiPad){
        minYpos = minYpos/2.0;
        maxYpos = maxYpos/2.0;
        xPos = xPos/2.0;
    }
    
    __block CGRect rect = hand.frame;
    
    if (animated) {
        [UIView animateWithDuration:0.05 animations:^(void){
            rect.origin.x = xPos-(hand.frame.size.width/2.0);
            rect.origin.y = minYpos;
            hand.frame = rect;
        } completion:^(BOOL finished){
            
        }];
    }else{
        rect.origin.x = xPos-(hand.frame.size.width/2.0);
        rect.origin.y = minYpos;
        hand.frame = rect;
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (readingState == ReadingStateNone || readingState == ReadingStateShowingImage){//only when reading finished.
        //only within words area:
        UITouch *touch = [touches anyObject];
        CGPoint locationInView = [touch locationInView:words];
        
        if (locationInView.y <= words.frame.size.height*3.0) {
            printf("touch at sentence %i\n",sentenceIndex);
            readingState = ReadingStatePlayingWordByUserTouch;
            [self playsoundForCurrentSentenceForWordAtPosition:locationInView.x];
        }
        
    }
}



-(void)dealloc{
    [pointerList release];
    [hand release];
    [words release];
    self.player = nil;
    [super dealloc];
}


@end
