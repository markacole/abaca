//
//  ABCabacaSongView.m
//  abaca
//
//  Created by Mark Cole on 31/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCabacaSongView.h"

@implementation ABCabacaSongView

@dynamic letter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float w = 1024.0/768.0*frame.size.height;
        bigLetter = [[UIImageView alloc] initWithFrame:CGRectMake(floorf((frame.size.width-w)/2.0), 0.0, w, frame.size.height)];
        [self addSubview:bigLetter];
    }
    return self;
}

-(void)setLetter:(NSString *)letter{
    if (_letter != nil){
        [_letter release];
        _letter = nil;
    }
    if (letter != nil) {
        _letter = [letter retain];
        
        NSString *imgName = [NSString stringWithFormat:@"%@/BigLetter_%@.png",[[NSBundle mainBundle] resourcePath],letter];
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:imgName];
        bigLetter.image = [UIImage imageWithData:imgData];
    }else{
        bigLetter.image = nil;
    }
    
}

-(NSString *)letter{
    return _letter;
}

-(void)dealloc{
    self.letter = nil;
    [bigLetter release];
    [super dealloc];
}

@end
