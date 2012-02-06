//
//  ABCyapYapSongViewController.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCyapYapSongViewController.h"


@interface ABCyapYapSongViewController (hidden)

-(void)startTimer;
-(void)stopTimer;

-(void)newVerse;
-(void)newLine;
-(void)newWord;
-(void)moveHandToPosition:(float)xPos animated:(BOOL)animated;


@end




@implementation ABCyapYapSongViewController

@synthesize player;
@synthesize timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"YapYapPointerList" ofType:@"plist"];
        pointerList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        CGRect screenFr = [[UIScreen mainScreen] bounds];
        if (screenFr.size.width == 768.0 || screenFr.size.width == 1024.0) isiPad = YES;
        else isiPad = NO;
        
        // Custom initialization
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/yap_yap_with_woof mark.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error = nil;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player = audioPlayer;
        [audioPlayer release];
        self.player.numberOfLoops = 0;
        self.player.volume = 1.0;
        self.player.delegate = self;
        [self.player prepareToPlay];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    
    
    pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!isiPad)pauseBtn.frame = CGRectMake(416.0, 0.0, 54.0, 54.0);
    else if (isiPad)pauseBtn.frame = CGRectMake(906.0, 0.0, 108.0, 108.0);
    [pauseBtn setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
    [pauseBtn setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
    [pauseBtn addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    
    hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand.png"]];
    if (isiPad) hand.frame = CGRectMake(0.0, 70.0, hand.frame.size.width, hand.frame.size.height);
    else hand.frame = CGRectMake(0.0, 35.0, hand.frame.size.width/2.0, hand.frame.size.height/2.0);
    [self.view addSubview:hand];
    hand.alpha = 0.0;
    
    float w = 1024;
    float h = 100.0;
    scale = 1.0;
    if (!isiPad){
        scale = 480/w;
        w = 480;
        h = floorf(h*scale);
    }
    
    
    if (isiPad) line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 140.0, w, h)];
    else line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0, w, h)];
    [self.view addSubview:line1];
    
    if (isiPad) line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 240.0, w, h)];
    else line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0+h, w, h)];
    [self.view addSubview:line2];
    
    if (isiPad) line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 340.0, w, h)];
    else line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0+h+h, w, h)];
    [self.view addSubview:line3];
}

-(void)viewDidAppear:(BOOL)animated{
    currentVerse = -1;
    currentLine = -1;
    currentWord = -1;
    
    [self startTimer];
    [self.player play];
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)homeButtonPressed:(id)sender{
    [self stopSound];
    [self stopTimer];
    [super homeButtonPressed:sender];
}


-(void)pauseButtonPressed:(id)sender{
    
    if (self.player.isPlaying){
        [self.player pause];
        [pauseBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [self stopTimer];
    }else{
        if (self.player.currentTime == 0.0) {
            currentVerse = -1;
            currentLine = -1;
            currentWord = -1;
        }
        [self startTimer];
        [self.player play];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
        
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

-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)stopTimer{
    if (self.timer){
        if (self.timer.isValid) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

-(void)timerFired{
    NSArray *verses = (NSArray *)[pointerList objectForKey:@"Verses"];
    
    BOOL lookAtLines = NO;
    BOOL lookAtWords = NO;
    
    if (currentVerse+1 < [verses count]){
        NSDictionary *nextVerse = (NSDictionary *)[verses objectAtIndex:currentVerse+1];
        float nextVerseTime = [[nextVerse objectForKey:@"VerseTime"] floatValue];
        if (self.player.currentTime >= nextVerseTime-1.0){
            [self newVerse];
            return;
        }else{
            //look at lines:
            lookAtLines = YES;
        }
    }else{
        //look at lines:
        lookAtLines = YES;
    }
    
    
    NSDictionary *thisVerse = (NSDictionary *)[verses objectAtIndex:currentVerse];
    NSArray *lines = (NSArray *)[thisVerse objectForKey:@"Lines"];
    
    if (lookAtLines) {
        
        if (currentLine+1 < [lines count]){
            NSDictionary *nextLine = (NSDictionary *)[lines objectAtIndex:currentLine+1];
            float nextLineTime = [[nextLine objectForKey:@"LineTime"] floatValue];
            if (self.player.currentTime >= nextLineTime-0.5) {
                
                currentLine++;
                [self newLine];
                return;
            }else{
                lookAtWords = YES;
            }
        }else{
            //look at words
            lookAtWords = YES;
        }
    }
    
    
    NSDictionary *thisLine = (NSDictionary *)[lines objectAtIndex:currentLine];
    NSArray *words = (NSArray *)[thisLine objectForKey:@"Words"];
    
    if (lookAtWords) {
        
        if (currentWord+1 < [words count]) {
            NSDictionary *nextWord = (NSDictionary *)[words objectAtIndex:currentWord+1];
            float nextWordTime = [[nextWord objectForKey:@"Time"] floatValue];
            if (self.player.currentTime >= nextWordTime-0.1) {
                currentWord++;
                [self newWord];
                return;
            }
        }
    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopTimer];
    self.player.currentTime = 0.0;
    [pauseBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    [pauseBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
}


-(void)newVerse{
    printf("V");
    currentVerse++;
    currentLine = 0;
    currentWord = 0;
    
    NSArray *verses = (NSArray *)[pointerList objectForKey:@"Verses"];
    if (currentVerse < [verses count]) {
        //clear all current lines and hand:
        [UIView animateWithDuration:0.2 animations:^(void){
            hand.alpha = 0.0;
            line1.alpha = 0.0;
            line2.alpha = 0.0;
            line3.alpha = 0.0;
        } completion:^(BOOL finished){
            line1.image = nil;
            line2.image = nil;
            line3.image = nil;
            [self newLine];
        }];
    }else{
        //end
    }
}

-(void)newLine{
    printf("L");
    currentWord = -1;
    
    NSArray *verses = (NSArray *)[pointerList objectForKey:@"Verses"];
    if (currentVerse < [verses count]) {
        NSDictionary *verse = (NSDictionary *)[verses objectAtIndex:currentVerse];
        NSArray *lines = (NSArray *)[verse objectForKey:@"Lines"];
        if (currentLine < [lines count]) {
            //show line
            UIImageView *thisImage = nil;
            float handY = 0.0;
            switch (currentLine) {
                case 0:{
                    line1.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%i_l1.png",currentVerse+1]];
                    thisImage = line1;
                    handY = line1.frame.origin.y+line1.frame.size.height;
                    break;
                }
                case 1:{
                    line2.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%i_l2.png",currentVerse+1]];
                    thisImage = line2;
                    handY = line2.frame.origin.y+line2.frame.size.height;
                    break;
                }
                case 2:{
                    line3.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%i_l3.png",currentVerse+1]];
                    thisImage = line3;
                    handY = line3.frame.origin.y+line3.frame.size.height;
                    break;
                }
                default:
                    break;
            }
            
            NSDictionary *line = (NSDictionary *)[lines objectAtIndex:currentLine];
            NSArray *words = (NSArray *)[line objectForKey:@"Words"];
            NSDictionary *word = (NSDictionary *)[words objectAtIndex:0];
            float wordX = [[word objectForKey:@"Pos"] floatValue];
            if (!isiPad){
                wordX = wordX*scale;
            }
            
            
            float handX = wordX-(hand.frame.size.width/2.0);
            
            
            CGRect handRect = hand.frame;
            handRect.origin.x = handX;
            handRect.origin.y = handY;
            
            hand.frame = handRect;
            
            [UIView animateWithDuration:0.2 animations:^(void){
                thisImage.alpha = 1.0;
                hand.alpha = 1.0;
            } completion:^(BOOL finished){
                //currentWord++;
            }];
        }else{
            
        }
    }
    
}

-(void)newWord{
    printf("W%i",currentWord);
    
    
    NSArray *verses = (NSArray *)[pointerList objectForKey:@"Verses"];
    NSDictionary *verse = (NSDictionary *)[verses objectAtIndex:currentVerse];
    NSArray *lines = (NSArray *)[verse objectForKey:@"Lines"];
    NSDictionary *line = (NSDictionary *)[lines objectAtIndex:currentLine];
    NSArray *words = (NSArray *)[line objectForKey:@"Words"];
    NSDictionary *word = (NSDictionary *)[words objectAtIndex:currentWord];
    float wordX = [[word objectForKey:@"Pos"] floatValue];
    
    [self moveHandToPosition:wordX animated:YES];
    
}


-(void)moveHandToPosition:(float)xPos animated:(BOOL)animated{
    
    
    if (!isiPad){
        xPos = xPos*scale;
    }
    
    __block CGRect rect = hand.frame;
    
    if (animated) {
        [UIView animateWithDuration:0.05 animations:^(void){
            rect.origin.x = xPos-(hand.frame.size.width/2.0);
            hand.frame = rect;
        } completion:^(BOOL finished){
            
        }];
    }else{
        rect.origin.x = xPos-(hand.frame.size.width/2.0);
        hand.frame = rect;
    }
}





-(void)dealloc{
    self.player = nil;
    self.timer = nil;
    [hand release];
    [pointerList release];
    [line1 release];
    [line2 release];
    [line3 release];
    [super dealloc];
}

@end
