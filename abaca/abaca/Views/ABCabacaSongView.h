//
//  ABCabacaSongView.h
//  abaca
//
//  Created by Mark Cole on 31/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCabacaSongView : UIView{
    UIImageView *bigLetter;
    
    NSString *_letter;
}

@property (nonatomic,retain) NSString *letter;


@end
