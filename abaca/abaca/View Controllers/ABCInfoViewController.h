//
//  ABCInfoViewController.h
//  abaca
//
//  Created by Mark Cole on 26/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface ABCInfoViewController : UIViewController <MFMailComposeViewControllerDelegate>


- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)webButtonPressed:(id)sender;

@end
