//
//  DataItems.h
//  TableViewObjC
//
//  Created by hoang dang trung on 9/8/15.
//  Copyright (c) 2015 hoang dang trung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItems : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSArray *data;


- (instancetype) initWithTitle: (NSString*) title andData: (NSArray*) data;

@end
