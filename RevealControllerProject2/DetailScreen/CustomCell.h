//
//  CustomCell.h
//  FunnyFood
//
//  Created by hoangdangtrung on 10/22/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSaleOff;

@end
