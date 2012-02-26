//
//  ABCalphabetViewController.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCalphabetViewController.h"
#import "NSArray+Helpers.h"

@interface ABCalphabetViewController (hidden)


-(void)playSoundForLetter:(NSString *)letter;
-(void)playFindForLetter:(NSString *)letter;
-(void)playFindLetterForLetter:(NSString *)letter;
-(void)playFanfare;
-(void)pickRandomLetterForFind;
-(void)startPlayMode;
-(void)startFindMode;
-(void)startNormalMode;
-(void)stopSound;
-(void)stopTimer;

@end




@implementation ABCalphabetViewController

@synthesize viewMode;
@synthesize alphabetView;
@synthesize player;
@synthesize playModeLettersOrder;
@synthesize playModeGapTimer;
@synthesize findLetter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewMode = ABCalphabetViewModeNormal;
        
        sexForFindArray = [[NSArray alloc] initWithObjects:
                           @"m",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"f",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"m",
                           @"f",
                           @"m",
                           @"m",
                           @"m",
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
    self.homeBtn.hidden = YES;
    
    ABCalphabetView *alphVw = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) alphVw = [[ABCalphabetView_iPhone alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) alphVw = [[ABCalphabetView_iPad alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    if (alphVw) {
        self.alphabetView = alphVw;
        [alphVw release];
        self.alphabetView.delegate = self;
        [self.view addSubview:self.alphabetView];
    }
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



-(void)alphabetLetterButtonPressedWithLetter:(NSString *)letter{
    if (self.viewMode == ABCalphabetViewModePlay) {
        [self startNormalMode];
        [self.alphabetView playCancelled];
        [self playSoundForLetter:letter];
    }else if (self.viewMode == ABCalphabetViewModeEye) {
        
    }else if (self.viewMode == ABCalphabetViewModeNormal){
        [self playSoundForLetter:letter];
    }
    
    
}


-(void)alphabetLetterButtonWasPressedInFindMode:(ABCalphabetButtonView *)alphabetButtonView correct:(BOOL)correct{
    if (correct) {
        [alphabetButtonView highlight];
        [self.alphabetView disableAlphaButtons];
        [self playFanfare];
    }else{
        findGuessCount++;
        if (findGuessCount > 2) {
            playedFind = NO;
            playedFindLetter = NO;
            playedFindFanfare = NO;
            findGuessCount = 0;
            [self playFindForLetter:self.findLetter];
        }
    }
}


-(void)homeButtonPressed{
    [self stopSound];
    [super homeButtonPressed:nil];
}

-(BOOL)pausePlayButtonPressedReturnIsPlaying{
    BOOL retVal = NO;
    if (self.viewMode == ABCalphabetViewModePlay){
        if (self.alphabetView.currentButton){
            [self.alphabetView.currentButton reset];
        }
        [self startNormalMode];
    }else{
        if (self.alphabetView.currentButton){
            [self.alphabetView.currentButton reset];
        }
        [self startPlayMode];
        retVal = YES;
    }
    return retVal;
}

-(void)findButtonPressed{
    if (self.viewMode != ABCalphabetViewModeEye) {
        if (self.alphabetView.currentButton){
            [self.alphabetView.currentButton reset];
        }
        [self startFindMode];
    }else{
        //repeat question
        if (![self.player isPlaying]){
            playedFind = NO;
            playedFindLetter = NO;
            playedFindFanfare = NO;
            findGuessCount = 0;
            [self playFindForLetter:self.findLetter];
        }
    }
    
}







-(void)startPlayMode{
    if (self.alphabetView.currentButton){
        [self.alphabetView.currentButton reset];
    }
    
    if (self.viewMode == ABCalphabetViewModeEye) {
        [self.alphabetView endFind];
        [self stopSound];
        [self stopTimer];
        ABCalphabetButtonView *buttonVw = [self.alphabetView getButtonWithLetter:self.findLetter];
        [buttonVw reset];
    }
    
    
    self.viewMode = ABCalphabetViewModePlay;
    
    //make an array of all 26 letters in random order:
    NSArray *alphabet = [NSArray arrayWithObjects:
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
    self.playModeLettersOrder = [alphabet shuffled];
    playModeCurrentIndex = 0;
    
    [self playSoundForLetter:[self.playModeLettersOrder objectAtIndex:playModeCurrentIndex]];
}

-(void)startFindMode{
    self.viewMode = ABCalphabetViewModeEye;
    playedFind = NO;
    playedFindLetter = NO;
    playedFindFanfare = NO;
    findGuessCount = 0;
    [self pickRandomLetterForFind];
}

-(void)startNormalMode{
    [self.alphabetView endFind];
    self.viewMode = ABCalphabetViewModeNormal;
    [self stopSound];
    [self stopTimer];
}





-(void)playSoundForLetter:(NSString *)letter{
    [self.alphabetView disableAlphaButtons];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sb_%@.mp3", [[NSBundle mainBundle] resourcePath],letter]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    [self.player play];
    
    if (self.viewMode == ABCalphabetViewModePlay) {
        self.alphabetView.currentButton = [self.alphabetView getButtonWithLetter:letter];
    }
    
}

-(void)playFindForLetter:(NSString *)letter{
    [self.alphabetView disableAlphaButtons];
    
    NSArray *alphabet = [NSArray arrayWithObjects:
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
    
    NSInteger indexOfLetter = 0;
    for (int i=0; i < [alphabet count]; i++){
        if ([[alphabet objectAtIndex:i] isEqualToString:letter]){
            indexOfLetter = i;
            break;
        }
    }
    
    NSString *sex = [sexForFindArray objectAtIndex:indexOfLetter];
    
    
    //pick a random number between 1 and 4
    NSUInteger randomNumber = (arc4random()%(4));
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/find_%@_%i.mp3", [[NSBundle mainBundle] resourcePath],sex,randomNumber]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    [self.player play];
}

-(void)playFindLetterForLetter:(NSString *)letter{
    
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/find_%@.mp3", [[NSBundle mainBundle] resourcePath],letter]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    [self.player play];
}

-(void)playFanfare{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/find_fanfare.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = audioPlayer;
    [audioPlayer release];
    self.player.numberOfLoops = 0;
    self.player.volume = 1.0;
    self.player.delegate = self;
    [self.player play];
}

-(void)pickRandomLetterForFind{
    NSArray *alphabet = [NSArray arrayWithObjects:
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
    self.findLetter = [[alphabet shuffled] objectAtIndex:13];
    [self.alphabetView setLetterForFind:self.findLetter];
    [self playFindForLetter:self.findLetter];
}




-(void)stopSound{
    [self.alphabetView enableAlphaButtons];
    if (self.player) {
        if (self.player.isPlaying) {
            [self.player stop];
        }
        self.player = nil;
    }
}

-(void)stopTimer{
    if (self.playModeGapTimer){
        if (self.playModeGapTimer.isValid){
            [self.playModeGapTimer invalidate];
        }
        self.playModeGapTimer = nil;
    }
}

-(void)timerFired{
    self.playModeGapTimer = nil;
    [self playSoundForLetter:[self.playModeLettersOrder objectAtIndex:playModeCurrentIndex]];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (alphabetView.currentButton != nil){
        [alphabetView.currentButton reset];
    }
    if (self.viewMode != ABCalphabetViewModeEye){
        [self.alphabetView enableAlphaButtons];
        if (self.viewMode == ABCalphabetViewModeNormal) {
            self.player = nil;
        }else if (self.viewMode == ABCalphabetViewModePlay) {
            self.player = nil;
            playModeCurrentIndex++;
            self.playModeGapTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
        }
    }else{
        if (!playedFind) {
            playedFind = YES;
            [self playFindLetterForLetter:self.findLetter];
        }else if (!playedFindLetter){
            playedFindLetter = YES;
            [self.alphabetView enableAlphaButtons];
        }else if (!playedFindFanfare){
            playedFindFanfare = YES;
            //play correct button:
            ABCalphabetButtonView *buttonVw = [self.alphabetView getButtonWithLetter:self.findLetter];
            [buttonVw highlight];
            [self playSoundForLetter:self.findLetter];
        }else{
            //reset
            ABCalphabetButtonView *buttonVw = [self.alphabetView getButtonWithLetter:self.findLetter];
            [buttonVw reset];
            [self.alphabetView endFind];
            [self.alphabetView enableAlphaButtons];
            self.viewMode = ABCalphabetViewModeNormal;
        }
    }
}


-(void)dealloc{
    self.player = nil;
    self.alphabetView = nil;
    self.playModeLettersOrder = nil;
    self.playModeGapTimer = nil;
    self.findLetter = nil;
    [sexForFindArray release];
    [super dealloc];
}

@end
