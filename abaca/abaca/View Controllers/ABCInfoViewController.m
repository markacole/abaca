//
//  ABCInfoViewController.m
//  abaca
//
//  Created by Mark Cole on 26/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCInfoViewController.h"

@implementation ABCInfoViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)rateButtonPressed:(id)sender {
    //open app store
}

- (IBAction)emailButtonPressed:(id)sender {
    //open email composer
    if ([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@""];
        
        
        NSArray *recipients = [[NSArray alloc] initWithObjects:@"info@gatehousebooks.com",nil];
        [picker setToRecipients:recipients];
        [recipients release];
        [picker setSubject:@""];
        
        [picker willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.0];
        
        if ([self isFirstResponder]) {
            [self resignFirstResponder];
        }
        
        // Present the mail composition interface.
        [self presentModalViewController:picker animated:YES];
        [picker release]; // Can safely release the controller now.
    }else{
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:nil message:@"To use this feature you must first set up an email account on this device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)webButtonPressed:(id)sender {
    //open web page in Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.yeswecanread.com"]];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
