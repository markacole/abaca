//
//  ABCreadingViewController.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"
#import "ABCReadingWordsView.h"
#import "ABCReadingImageView.h"

@interface ABCreadingViewController : ABCBaseViewController<ABCReadingWordsViewDelegate>{
    ABCReadingImageView *mainImageView;
    ABCReadingWordsView *wordsView;
    
    CGRect catRect;
    CGPoint catCenter;
}


@property (nonatomic,retain) UIImageView *firstBtn;

@end
