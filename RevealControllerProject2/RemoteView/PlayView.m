//
//  PlayView.m
//  ZingClone
//
//  Created by suke on 6/6/16.
//
//

#import "PlayView.h"

@implementation PlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    [self addRotateImage];

}

- ( void) addRotateImage {
    UIView *playView = [[UIView alloc]initWithFrame:CGRectMake(3, 2, 40, 40)];
    UIImage *image = [UIImage imageNamed:@""];
    [playView addSubview:image.images];
}

@end
