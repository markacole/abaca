//
//  ABCalphabetViewController.h
//  abaca
//
//  Created by Mark Cole on 30/01/2012.
//  Copyright (c) 2012 SeriouslyRevival. All rights reserved.
//

#import "ABCBaseViewController.h"

typedef enum{
    ABCalphabetViewModeNormal,
    ABCalphabetViewModePlay,
    ABCalphabetViewModeEye
}ABCalphabetViewMode;

@interface ABCalphabetViewController : ABCBaseViewController

@property (nonatomic) ABCalphabetViewMode viewMode;

@end
