//
//  ABCBaseViewController.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"

@implementation ABCBaseViewController

@synthesize homeBtn;

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
    
    self.view.multipleTouchEnabled = NO;
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBGGradient.png"]];
    [self.view addSubview:bg];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)bg.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)bg.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    [bg release];
    
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)homeBtn.frame = CGRectMake(10.0, 0.0, 54.0, 54.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)homeBtn.frame = CGRectMake(10.0, 0.0, 108.0, 108.0);
    [homeBtn setImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"HomeButton_Highlighted.png"] forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)homeButtonPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
