//
//  ABCRootViewController.m
//  abaca
//
//  Created by Mark Cole on 29/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCRootViewController.h"

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *vw =[[UIView alloc] initWithFrame:CGRectZero];
    self.view = vw;
    [vw release];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBGGradient.png"]];
    [self.view addSubview:bg];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)bg.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)bg.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    
    
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

@end
