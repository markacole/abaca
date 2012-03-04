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
@synthesize previous;
@synthesize next;

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
        audioPlayer.enableRate = YES;
        [audioPlayer prepareToPlay];
        
        
        currentPage = 0;
        
        times = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithFloat:0.0],//a
                 [NSNumber numberWithFloat:8.558],//b
                 [NSNumber numberWithFloat:12.125],//c
                 [NSNumber numberWithFloat:15.717],//d
                 [NSNumber numberWithFloat:22.775],//e
                 [NSNumber numberWithFloat:26.342],//f
                 [NSNumber numberWithFloat:29.892],//g
                 [NSNumber numberWithFloat:33.458],//h
                 [NSNumber numberWithFloat:40.575],//i
                 [NSNumber numberWithFloat:44.125],//j
                 [NSNumber numberWithFloat:47.675],//k
                 [NSNumber numberWithFloat:51.242],//l
                 [NSNumber numberWithFloat:58.333],//m
                 [NSNumber numberWithFloat:61.9],//n
                 [NSNumber numberWithFloat:65.458],//o
                 [NSNumber numberWithFloat:69.017],//p
                 [NSNumber numberWithFloat:76.125],//q
                 [NSNumber numberWithFloat:79.675],//r
                 [NSNumber numberWithFloat:83.192],//s
                 [NSNumber numberWithFloat:86.8],//t
                 [NSNumber numberWithFloat:93.908],//u
                 [NSNumber numberWithFloat:97.425],//v
                 [NSNumber numberWithFloat:100.933],//w
                 [NSNumber numberWithFloat:104.542 ],//x
                 [NSNumber numberWithFloat:111.450],//y
                 [NSNumber numberWithFloat:115.108],//z
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
        
        speeds = [[NSArray alloc] initWithObjects:
                  [NSNumber numberWithFloat:(1.0/1.5/1.5)],
                  [NSNumber numberWithFloat:(1.0/1.5)],
                  [NSNumber numberWithFloat:1.0],
                  [NSNumber numberWithFloat:(1.0*1.5)],
                  [NSNumber numberWithFloat:(1.0*1.5*1.5)],
                  nil];
        
        speedIndex = 2;
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
    
    
    speedControlMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    speedControlPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    speedControlMinus.showsTouchWhenHighlighted = YES;
    speedControlPlus.showsTouchWhenHighlighted = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) speedControlMinus.frame = CGRectMake(350.0, 270.0, 44.0, 44.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) speedControlMinus.frame = CGRectMake(800.0, 660.0, 88.0, 88.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) speedControlPlus.frame = CGRectMake(408.0, 270.0, 44.0, 44.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) speedControlPlus.frame = CGRectMake(916.0, 660.0, 88.0, 88.0);
    [speedControlMinus addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [speedControlPlus addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speedControlMinus];
    [self.view addSubview:speedControlPlus];
    
    
    speedControlMinusImg = [[UIImageView alloc] initWithFrame:speedControlMinus.frame];
    speedControlPlusImg = [[UIImageView alloc] initWithFrame:speedControlPlus.frame];
    [self.view insertSubview:speedControlMinusImg belowSubview:speedControlMinus];
    [self.view insertSubview:speedControlPlusImg belowSubview:speedControlPlus];
    speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft@2x.png"];
    speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight@2x.png"];
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
        float speed = [[speeds objectAtIndex:speedIndex] floatValue];
        audioPlayer.rate = speed;
        [audioPlayer play];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [pauseBtn setImage:[UIImage imageNamed:@"PauseButton_Highlighted.png"] forState:UIControlStateHighlighted];
        [self startTimer];
    }
    
    
}

-(void)changeSpeed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn == speedControlMinus){
        if (speedIndex != 0) {
            speedIndex--;
        }
    }else if (btn == speedControlPlus){
        if (speedIndex != [speeds count]-1) {
            speedIndex++;
        }
    }
    float speed = [[speeds objectAtIndex:speedIndex] floatValue];
    audioPlayer.rate = speed;
    
    switch (speedIndex) {
        case 0:{
            speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft3@2x.png"];
            speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight@2x.png"];
            break;
        }
        case 1:{
            speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft2@2x.png"];
            speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight@2x.png"];
            break;
        }
        case 2:{
            speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft@2x.png"];
            speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight@2x.png"];
            break;
        }
        case 3:{
            speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft@2x.png"];
            speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight2@2x.png"];
            break;
        }
        case 4:{
            speedControlMinusImg.image = [UIImage imageNamed:@"chevronsLeft@2x.png"];
            speedControlPlusImg.image = [UIImage imageNamed:@"chevronsRight3@2x.png"];
            break;
        }
        default:
            break;
    }
}


-(void)showNext{
    
    
    ABCabacaSongView *nxt = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) nxt = [[ABCabacaSongView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) nxt = [[ABCabacaSongView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    
    //move previous to the left and remove; fade in next
    if (nxt){
        self.next = nxt;
        [nxt release];
        
        
        if (currentPage < [alphabet count]) {
            self.next.letter = [alphabet objectAtIndex:currentPage];
            self.next.alpha = 0.0;
            [songViewContainer addSubview:self.next];
        }else{
            [self endTimer];
        }
        currentPage++;
        
    }
    
    float rate = 0.3/audioPlayer.rate;
    
    if (self.previous) {
        [UIView animateWithDuration:rate 
                         animations:^(void){
                             float w = self.previous.frame.size.width;
                             CGRect rect = self.previous.frame;
                             rect.origin.x -= w;
                             self.previous.frame = rect;
        } 
                         completion:^(BOOL finished){
                             [self.previous removeFromSuperview];
                             self.previous = self.next;
                             [UIView animateWithDuration:rate 
                                              animations:^(void){
                                                  self.next.alpha = 1.0;
                                              } 
                                              completion:^(BOOL finished){
                                                  self.next = nil;
                                              }];
        }];
    }else{
        [UIView animateWithDuration:rate 
                         animations:^(void){
                             self.previous = self.next;
                             self.previous.alpha = 1.0;
                         } 
                         completion:^(BOOL finished){
                             self.next = nil;
                         }];
    }
    
    
}

-(void)startTimer{
    [self endTimer];
    self.songProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkProgress) userInfo:nil repeats:YES];
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
        if (current >= [[times objectAtIndex:currentPage] floatValue]-0.8){
            [self showNext];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    musicEnded = YES;
    [self endTimer];
    currentPage = 0;
    audioPlayer.currentTime = 0.00;
    [pauseBtn setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    [pauseBtn setImage:[UIImage imageNamed:@"PlayButton_Highlighted.png"] forState:UIControlStateHighlighted];
    [self checkProgress];
}


-(void)dealloc{
    [times release];
    [alphabet release];
    [speeds release];
    [speedControlMinusImg release];
    [speedControlPlusImg release];
    [songViewContainer  release];
    [audioPlayer release];
    self.previous = nil;
    self.next = nil;
    //[song release];
    [super dealloc];
}

@end
