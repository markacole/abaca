//
//  ABCRootViewController.m
//  abaca
//
//  Created by Mark Cole on 29/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCRootViewController.h"
#import "ABCabacaSongViewController.h"
#import "ABCalphabetViewController.h"
#import "ABCreadingViewController.h"
#import "ABCyapYapSongViewController.h"
#import "ABCInfoViewController-iPhone.h"

@implementation ABCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIView *vw =[[UIView alloc] initWithFrame:CGRectZero];
    self.view = vw;
    [vw release];
    
    
    self.view.exclusiveTouch = YES;
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:150.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    /*UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBGGradient.png"]];
    [self.view addSubview:bg];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)bg.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)bg.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    [bg release];*/
    
    
    NSArray *btnTitles = [[NSArray alloc] initWithObjects:
                          @"abaca song",
                          @"alphabet",
                          @"reading",
                          @"yap yap song",
                          nil];
    
    
    float btnW = 320.0;
    float btnH = 54.0;
    float gapH = 20.0;
    float btnX = floorf((480.0-btnW)/2.0);
    float btnY = floorf(  (320.0-( (btnH*[btnTitles count]) + (gapH*([btnTitles count]-1)) ))/2.0  );
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        btnW = btnW*2.0;
        btnH = btnH*2.0;
        gapH = gapH*2.0;
        btnX = floorf((1024.0-btnW)/2.0);
        btnY = floorf(  (768.0-( (btnH*[btnTitles count]) + (gapH*([btnTitles count]-1)) ))/2.0  );
    }
    
    for (int i=0; i<[btnTitles count]; i++){
        ABCHomeScreenButtonView *btn = [[ABCHomeScreenButtonView alloc] initWithFrame:CGRectMake(btnX, i*(btnH+gapH)+btnY, btnW, btnH)];
        btn.exclusiveTouch = YES;
        btn.tag = i;
        btn.delegate = self;
        NSString *textImageName = [NSString stringWithFormat:@"HomeScreenBtnText_%i.png",i];
        NSString *iconImageName = [NSString stringWithFormat:@"HomeScreenBtnIcon_%i.png",i];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            textImageName = [NSString stringWithFormat:@"HomeScreenBtnText_%i@2x.png",i];
            iconImageName = [NSString stringWithFormat:@"HomeScreenBtnIcon_%i@2x.png",i];
        }
        [btn setTextImage:[UIImage imageNamed:textImageName]];
        [btn setIconImage:[UIImage imageNamed:iconImageName]];
        
        [self.view addSubview:btn];
        [btn release];
    }
    
    
    [btnTitles release];
    
    
    muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)muteButton.frame = CGRectMake(10.0, 0.0, 54.0, 54.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)muteButton.frame = CGRectMake(10.0, 0.0, 108.0, 108.0);
    [muteButton setImage:[UIImage imageNamed:@"MuteButton_Muted.png"] forState:UIControlStateNormal];
    [muteButton setImage:[UIImage imageNamed:@"MuteButton_Muted_Highlighted.png"] forState:UIControlStateHighlighted];
    [muteButton addTarget:self action:@selector(muteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:muteButton];
    
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoBtn.showsTouchWhenHighlighted = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)infoBtn.frame = CGRectMake(416.0, 0.0, 54.0, 54.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)infoBtn.frame = CGRectMake(906.0, 0.0, 108.0, 108.0);
    [infoBtn addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
    
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/a_apple_mix_2_FINAL.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error = nil;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 0.2;
    [audioPlayer prepareToPlay];
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


-(void)homeScreenButtonPressed:(ABCHomeScreenButtonView *)buttonView{
    UIViewController *newVC = nil;
    switch (buttonView.tag) {
        case 0:
            newVC = [[ABCabacaSongViewController alloc] init];
            break;
        case 1:
            newVC = [[ABCalphabetViewController alloc] init];
            break;
        case 2:
            newVC = [[ABCreadingViewController alloc] init];
            break;
        case 3:
            newVC = [[ABCyapYapSongViewController alloc] init];
            break;
        default:
            break;
    }
    if (newVC){
        if (audioPlayer != nil)[audioPlayer stop];
        [self.navigationController pushViewController:newVC animated:YES];
    }
}

-(void)muteButtonPressed:(id)sender{
    if (audioPlayer.volume > 0.0) {
        audioPlayer.volume = 0.0;
        [muteButton setImage:[UIImage imageNamed:@"MuteButton.png"] forState:UIControlStateNormal];
        [muteButton setImage:[UIImage imageNamed:@"MuteButton_Highlighted.png"] forState:UIControlStateHighlighted];
    }else{
        audioPlayer.volume = 0.2;
        [muteButton setImage:[UIImage imageNamed:@"MuteButton_Muted.png"] forState:UIControlStateNormal];
        [muteButton setImage:[UIImage imageNamed:@"MuteButton_Muted_Highlighted.png"] forState:UIControlStateHighlighted];
    }
}


-(void)infoButtonPressed:(id)sender{
    ABCInfoViewController *info = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)info = [[ABCInfoViewController alloc] initWithNibName:@"ABCInfoViewController" bundle:[NSBundle mainBundle]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  info = [[ABCInfoViewController_iPhone alloc] initWithNibName:@"ABCInfoViewController-iPhone" bundle:[NSBundle mainBundle]];
    
    [audioPlayer pause];
    
    [self presentModalViewController:info animated:YES];
    [info release];
}


-(void)dealloc{
    [audioPlayer release];
    [super dealloc];
}

@end
