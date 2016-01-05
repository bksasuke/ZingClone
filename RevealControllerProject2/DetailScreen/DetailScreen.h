//
//  DetailScreen.h
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/22/15.
//
//

#import <UIKit/UIKit.h>

@interface DetailScreen : UIViewController
@property (nonatomic, strong) NSString *stringLinkImage;
@property (nonatomic, strong) NSString *stringLinkDetail;
@property (nonatomic, strong) NSString *stringHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *linkMp3;
@end
