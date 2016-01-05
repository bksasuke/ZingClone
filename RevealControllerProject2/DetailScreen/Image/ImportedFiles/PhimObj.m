//
//  PhimObj.m
//  CGVAPP
//
//  Created by Nguyen Van Thanh on 12/7/15.
//  Copyright © 2015 DangDingCan. All rights reserved.
//

#import "PhimObj.h"

@interface PhimObj()


@end


@implementation PhimObj
- (id)initWithName:(NSString *)name
          catelogy:(NSString *)catelogy
          duration:(NSString *)duration
              date:(NSString *)date
        linkDetail:(NSString *)linkDetail
          imageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        self.tenPhim = name;
        self.theLoai = catelogy;
        self.thoiLuong = duration;
        self.khoiChieu = date;
        self.linkChitiet = linkDetail;
        self.linkAnh = imageUrl;
    }
    return self;
}



@end
