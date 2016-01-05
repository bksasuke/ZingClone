//
//  PhimObj.h
//  CGVAPP
//
//  Created by Nguyen Van Thanh on 12/7/15.
//  Copyright © 2015 DangDingCan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhimObj : NSObject
@property (nonatomic, strong) NSString * tenPhim;
@property (nonatomic, strong) NSString * theLoai;
@property (nonatomic, strong) NSString * thoiLuong;
@property (nonatomic, strong) NSString * khoiChieu;
@property (nonatomic, strong) NSString * linkChitiet;
@property (nonatomic, strong) NSString * linkAnh;
-(id) initWithName:(NSString *) name
          catelogy:(NSString *) catelogy
          duration:(NSString *) duration
              date:(NSString *) date
        linkDetail:(NSString *) linkDetail
          imageUrl:(NSString *) imageUrl;




@end
