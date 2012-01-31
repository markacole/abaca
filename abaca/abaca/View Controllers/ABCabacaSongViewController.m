//
//  ABCabacaSongViewController.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCabacaSongViewController.h"


@interface ABCabacaSongViewController (hidden){
    
}

-(void)showNext;
-(void)startTimer;
-(void)endTimer;
-(void)checkProgress;

@end



@implementation ABCabacaSongViewController


@synthesize songProgressTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //song = [[ABCabacaSong alloc] init];
        
        musicEnded = YES;
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/a_apple_mix_2_FINAL.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error = nil;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        audioPlayer.volume = 1.0;
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        
        alphaViews = [[NSMutableArray alloc] initWithCapacity:2];
        
        currentPage = 0;
        
        /*
         a - 4
         b - 7.5
         c - 11
         d - 15
         e - 22
         f - 25.5
         g - 29
         h - 32.5
         i - 39.5
         j - 43
         k - 47
         l - 50.3
         m - 57.5
         n - 61
         o - 65
         p - 68
         q - 75
         r - 78.8
         s - 82.5
         t - 86
         u - 93
         v - 96.5
         w - 100
         x - 103.5
         y - 110.5
         z - 114
         */
        times = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithFloat:0.0],//a
                 [NSNumber numberWithFloat:7.5],//b
                 [NSNumber numberWithFloat:11.0],//c
                 [NSNumber numberWithFloat:15.0],//d
                 [NSNumber numberWithFloat:22.0],//e
                 [NSNumber numberWithFloat:25.5],//f
                 [NSNumber numberWithFloat:28.5],//g
                 [NSNumber numberWithFloat:32.5],//h
                 [NSNumber numberWithFloat:39.5],//i
                 [NSNumber numberWithFloat:43.0],//j
                 [NSNumber numberWithFloat:46.5],//k
                 [NSNumber numberWithFloat:50.3],//l
                 [NSNumber numberWithFloat:57.5],//m
                 [NSNumber numberWithFloat:61.0],//n
                 [NSNumber numberWithFloat:64.5],//o
                 [NSNumber numberWithFloat:68.0],//p
                 [NSNumber numberWithFloat:75.0],//q
                 [NSNumber numberWithFloat:78.8],//r
                 [NSNumber numberWithFloat:82.0],//s
                 [NSNumber numberWithFloat:85.5],//t
                 [NSNumber numberWithFloat:93.0],//u
                 [NSNumber numberWithFloat:96.5],//v
                 [NSNumber numberWithFloat:100.0],//w
                 [NSNumber numberWithFloat:103.5],//x
                 [NSNumber numberWithFloat:110.5],//y
                 [NSNumber numberWithFloat:114.0],//z
                 nil];
        
        alphabet = [[NSArray alloc] initWithObjects:
                    @"a",
                    @"b",
                    @"c",
                    @"d",
                    @"e",
                    @"f",
                    @"g",
                    @"h",
                    @"i",
                    @"j",
                    @"k",
                    @"l",
                    @"m",
                    @"n",
                    @"o",
                    @"p",
                    @"q",
                    @"r",
                    @"s",
                    @"t",
                    @"u",
                    @"v",
                    @"w",
                    @"x",
                    @"y",
                    @"z",
                    nil];
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
    
    //[song startGraph];
    //[song changePitch:0.5];
    
    pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)pauseBtn.frame = CGRectMake(416.0, 0.0, 54.0, 54.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)pauseBtn.frame = CGRectMake(906.0, 0.0, 108.0, 108.0);
    [pauseBtn setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
    [pauseBtn setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
    [pauseBtn addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    
    songViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)songViewContainer.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)songViewContainer.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    [self.view insertSubview:songViewContainer atIndex:1];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(void)viewDidAppear:(BOOL)animated{
    if (audioPlayer != nil){
        audioPlayer.currentTime = 0;
        [audioPlayer play];
    }
    
    [self startTimer];
    musicEnded = NO;
}

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
    if (audioPlayer != nil)[audioPlayer stop];
    [self endTimer];
    [super homeButtonPressed:sender];
}

-(void)pauseButtonPressed:(id)sender{
    if (audioPlayer.isPlaying){
        [audioPlayer pause];
        [pauseBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [self endTimer];
    }else{
        [audioPlayer play];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [self startTimer];
    }
}


-(void)showNext{
    
    ABCabacaSongView *previous = nil;
    if ([alphaViews count] > 0) previous = (ABCabacaSongView *)[alphaViews objectAtIndex:0];
    
    ABCabacaSongView *next = nil;
    if (currentPage < 26){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) next = [[ABCabacaSongView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0)];
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) next = [[ABCabacaSongView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    }
    //move previous to the left and remove; fade in next
    if (next){
        if (currentPage < [alphabet count]) {
            next.letter = [alphabet objectAtIndex:currentPage];
            next.alpha = 0.0;
            [alphaViews addObject:next];
            [songViewContainer addSubview:next];
        }else{
            [self endTimer];
        }
        currentPage++;
        [next release];
    }
    
    [UIView animateWithDuration:0.6 animations:^(void){
        if (previous){
            float w = previous.frame.size.width;
            CGRect rect = previous.frame;
            rect.origin.x -= w;
            previous.frame = rect;
        }
        if (next) {
            next.alpha = 1.0;
        }
    } completion:^(BOOL finished){
        if (previous) {
            [alphaViews removeObject:previous];
        }
    }];
    
}

-(void)startTimer{
    [self endTimer];
    self.songProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkProgress) userInfo:nil repeats:YES];
}

-(void)endTimer{
    if (self.songProgressTimer != nil){
        if ([self.songProgressTimer isValid]){
            [self.songProgressTimer invalidate];
        }
        self.songProgressTimer = nil;
    }
}


-(void)checkProgress{
    float current = audioPlayer.currentTime;
    if (currentPage < [times count]) {
        if (current > [[times objectAtIndex:currentPage] floatValue]){
            [self showNext];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}


-(void)dealloc{
    [songViewContainer  release];
    [alphaViews release];
    [audioPlayer release];
    //[song release];
    [super dealloc];
}

@end
