//
//  ABCReadingImageView.m
//  abaca
//
//  Created by Mark Cole on 02/02/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCReadingImageView.h"

@interface ABCReadingImageView (hidden)

-(void)playSoundAtURLString:(NSString *)urlString;

@end





@implementation ABCReadingImageView

@synthesize player;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [self addSubview:imgVw];
    }
    return self;
}




-(void)showImageAtIndex:(NSInteger)index{
    currentImageIndex = index;
    NSString *imgName = [NSString stringWithFormat:@"%@/readingImg_%i.png",[[NSBundle mainBundle] resourcePath],index];
    NSData *imgData = [[NSData alloc] initWithContentsOfFile:imgName];
    imgVw.image = [UIImage imageWithData:imgData];
    imgVw.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^(void){
        imgVw.alpha = 1.0;
        [self playSound];
    }];
}

-(void)hideImage{
    [UIView animateWithDuration:0.3 animations:^(void){
        imgVw.alpha = 0.0;
    } completion:^(BOOL finished){
        imgVw.image = nil;
    }];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    printf("touch");
    if (imgVw.image != nil){
        UITouch *touch = [touches anyObject];
        printf(" - image!");
        
        switch (currentImageIndex) {
            case 0:{
                //for image 0 there are two sounds. If user touched on/near mouse, the mouse sound plays, else the cat sound plays.
                CGPoint locationInView = [touch locationInView:[touch view]];
                CGRect mouseLocation = CGRectMake(300.0, 44.0, 150.0, 130.0);
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) mouseLocation = CGRectMake(150.0, 22.0, 75.0, 65.0);
                if (locationInView.x > mouseLocation.origin.x &&
                    locationInView.x < (mouseLocation.origin.x+mouseLocation.size.width) &&
                    locationInView.y > mouseLocation.origin.y &&
                    locationInView.y < (mouseLocation.origin.y+mouseLocation.size.height)) {
                    NSString *url = [NSString stringWithFormat:@"%@/sounds_0_a.wav", [[NSBundle mainBundle] resourcePath]];
                    [self playSoundAtURLString:url];
                }else{
                    NSString *url = [NSString stringWithFormat:@"%@/sounds_0_b.mp3", [[NSBundle mainBundle] resourcePath]];
                    [self playSoundAtURLString:url];
                }
                
                break;
            }
            case 1:{
                NSString *url = [NSString stringWithFormat:@"%@/sounds_1.wav", [[NSBundle mainBundle] resourcePath]];
                [self playSoundAtURLString:url];
                break;
            }
            case 2:{
                NSString *url = [NSString stringWithFormat:@"%@/sounds_2.mp3", [[NSBundle mainBundle] resourcePath]];
                [self playSoundAtURLString:url];
                break;
            }
            case 3:{
                NSString *url = [NSString stringWithFormat:@"%@/sounds_3.mp3", [[NSBundle mainBundle] resourcePath]];
                [self playSoundAtURLString:url];
                break;
            }
            case 4:{
                NSString *url = [NSString stringWithFormat:@"%@/sounds_4.wav", [[NSBundle mainBundle] resourcePath]];
                [self playSoundAtURLString:url];
                break;
            }
            default:
                break;
        }
        
        
    }
    printf("\n");
}

-(void)playSound{
    switch (currentImageIndex) {
        case 0:{
            NSString *url = [NSString stringWithFormat:@"%@/sounds_0_a.wav", [[NSBundle mainBundle] resourcePath]];
            [self playSoundAtURLString:url];
            break;
        }
        case 1:{
            NSString *url = [NSString stringWithFormat:@"%@/sounds_1.wav", [[NSBundle mainBundle] resourcePath]];
            [self playSoundAtURLString:url];
            break;
        }
        case 2:{
            NSString *url = [NSString stringWithFormat:@"%@/sounds_2.mp3", [[NSBundle mainBundle] resourcePath]];
            [self playSoundAtURLString:url];
            break;
        }
        case 3:{
            NSString *url = [NSString stringWithFormat:@"%@/sounds_3.mp3", [[NSBundle mainBundle] resourcePath]];
            [self playSoundAtURLString:url];
            break;
        }
        case 4:{
            NSString *url = [NSString stringWithFormat:@"%@/sounds_4.wav", [[NSBundle mainBundle] resourcePath]];
            [self playSoundAtURLString:url];
            break;
        }
        default:
            break;
    }
}


-(void)playSoundAtURLString:(NSString *)urlString{
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        self.player = audioPlayer;
        [audioPlayer release];
        self.player.numberOfLoops = 0;
        self.player.volume = 1.0;
        self.player.delegate = self;
        self.player.currentTime = 0;
        [self.player play];
    }
}


-(void)dealloc{
    [imgVw release];
    [super dealloc];
}

@end
