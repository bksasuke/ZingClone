//
//  AppController.m
//  ZingClone
//
//  Created by suke on 6/13/16.
//
//

#import "AppController.h"

static AppController *sharedInstance = nil;
@implementation AppController

+ (AppController *)sharedInstance
{
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppController alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

@end
