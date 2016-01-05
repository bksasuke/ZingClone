//
//  DataItem.m
//  FunnyFood
//
//  Created by hoangdangtrung on 10/22/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (instancetype) initWithName: (NSString*)name
                     andPrice: (NSString*)price
                    withImage: (NSString*)image
              andSaleOffPrice: (NSString*)saleOff {
    
    if (self = [super init]) {
        self.name = name;
        self.price = price;
        self.image = [UIImage imageNamed:image];
        self.saleOff = saleOff;
    }
    return self;
}


@end
