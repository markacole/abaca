//
//  ABCreadingViewController.m
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCreadingViewController.h"
@interface ABCreadingViewController (hidden)

-(void)beginCatAnimation;
-(void)endCatAnimation;

@end


@implementation ABCreadingViewController


@synthesize firstBtn;



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
    [super loadView];
    
    
    float startY = 120.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) startY = startY/2.0;
    
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imgName = [NSString stringWithFormat:@"readBtn_%i.png",i];
        UIImage *btnImg = [UIImage imageNamed:imgName];
        
        [btn addTarget:self action:@selector(animalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        CGSize imgSize = btnImg.size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            imgSize.width = imgSize.width/2.5;
            imgSize.height = imgSize.height/2.5;
            
        }
        
        btn.frame = CGRectMake(10.0, startY, imgSize.width, imgSize.height);
        startY += imgSize.height;
        
        [self.view addSubview:btn];
        
        if (i==0){
            
            catRect = btn.frame;
            catCenter = btn.center;
            
            
            UIImageView *catImg = [[UIImageView alloc] initWithImage:btnImg];
            catImg.tag = 1000;
            catImg.frame = btn.frame;
            [self.view insertSubview:catImg belowSubview:btn];
            [catImg release];
        }else{
            [btn setImage:btnImg forState:UIControlStateNormal];
        }
        
        
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) mainImageView = [[ABCReadingImageView alloc] initWithFrame:CGRectMake(100.0, 10.0, 370.0, 200.0)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) mainImageView = [[ABCReadingImageView alloc] initWithFrame:CGRectMake(230.0, 85.0, 740.0, 400.0)];
    [self.view addSubview:mainImageView];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) wordsView = [[ABCReadingWordsView alloc] initWithFrame:CGRectMake(100.0, 210.0, 370.0, 100.0)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) wordsView = [[ABCReadingWordsView alloc] initWithFrame:CGRectMake(230.0, 500.0, 740.0, 200.0)];
    [self.view addSubview:wordsView];
    wordsView.delegate = self;
    
    
    [self beginCatAnimation];
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



-(void)beginCatAnimation{
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    CGRect expandToRect = CGRectMake(0.0, 0.0, floorf(catRect.size.width*1.2), floorf(catRect.size.height*1.2));
    expandToRect.origin.x = floorf((btn.frame.size.width-expandToRect.size.width)/2.0+btn.frame.origin.x);
    expandToRect.origin.y = floorf((btn.frame.size.height-expandToRect.size.height)/2.0+btn.frame.origin.y);
    UIImageView *img = (UIImageView *)[self.view viewWithTag:1000];
    [UIView animateWithDuration:0.8 
                          delay:0.3 
                        options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAutoreverse 
                     animations:^(void){
                         img.frame = expandToRect;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)endCatAnimation{
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    UIImageView *img = (UIImageView *)[self.view viewWithTag:1000];
    if (img) {
        [UIView animateWithDuration:0.3 animations:^(void){
            img.frame = btn.frame;
        }
                         completion:^(BOOL finished){
                             [btn setImage:img.image forState:UIControlStateNormal];
                             [img removeFromSuperview];
                             
                         }];
    }
    
}



-(void)animalButtonPressed:(id)sender{
    [self endCatAnimation];
    UIButton *btn = (UIButton *)sender;
    [wordsView startWordsWithIndex:btn.tag-100];
}


-(void)homeButtonPressed:(id)sender{
    [wordsView stop];
    [super homeButtonPressed:sender];
}


-(void)readingWordsViewDidChangeSentenceIndex:(ABCReadingWordsView *)readingWordsView{
    
}

-(void)readingWordsViewHideImage{
    [mainImageView hideImage];
}

-(void)readingWordsViewShowImage{
    [mainImageView showImageAtIndex:wordsView.sentenceIndex];
}

-(void)dealloc{
    self.firstBtn = nil;
    [mainImageView release];
    [wordsView release];
    [super dealloc];
}

@end
