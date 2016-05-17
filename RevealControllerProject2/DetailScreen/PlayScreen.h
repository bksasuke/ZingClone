//
//  PlayScreen.h
//  FunnyFood
//
//  Created by hoangdangtrung on 10/23/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PlayScreen : UIViewController

@property(nonatomic, strong) NSString *stringNameFood,*strImage;
@property (weak, nonatomic) IBOutlet UIView *imgPlay;
@property (weak, nonatomic) IBOutlet UISlider *sliderShowCurrentTime;


@property(nonatomic,strong) NSString *linkMp3;

@end
