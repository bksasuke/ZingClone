//
//  DataItems.m
//  TableViewObjC
//
//  Created by hoang dang trung on 9/8/15.
//  Copyright (c) 2015 hoang dang trung. All rights reserved.
//

#import "DataItems.h"

@implementation DataItems
- (instancetype) initWithTitle: (NSString*) title andData: (NSArray*) data{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.data = data;
    }
    return self;
}


@end
