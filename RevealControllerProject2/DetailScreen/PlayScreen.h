//
//  PlayScreen.h
//  FunnyFood
//
//  Created by hoangdangtrung on 10/23/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGViewController.h"
@interface PlayScreen : UIViewController//ICGViewController

@property(nonatomic, strong) NSString *stringNameFood,*strImage;
@property (weak, nonatomic) IBOutlet UIView *imgPlay;
@property (weak, nonatomic) IBOutlet UISlider *sliderShowCurrentTime;

@property(nonatomic,strong) NSString *linkMp3;
@property(nonatomic,strong) NSString *currentLinkMp3;

@end
