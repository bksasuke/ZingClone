//
//  NSObject+Chanel.m
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/18/15.
//
//

#import "Chanel.h"
@interface Chanel ()
@end

@implementation Chanel

-(id) initWithName:(NSString *)name
             image:(NSString *)image
        linkchanel:(NSString *)linkChanel
{ self = [super init];
    if (self) {
        self.chude =name;
        self.image = image;
        self.linkChanel =linkChanel;
    }
    return self;
}

@end
