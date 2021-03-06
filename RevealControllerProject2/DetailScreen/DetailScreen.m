//
//  DetailScreen.m
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/22/15.
//
//

#import "DetailScreen.h"
#import "FrontViewController.h"
#import "PhimObj.h"
#import "NetworkManager.h"
#import "PlayScreen.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"
@interface DetailScreen () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arr_data;
}
@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, weak) NSString *desLink ;

@property (nonatomic,strong) PlayScreen *PlayScreen;
@end

@implementation DetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
//                                                                         style:UIBarButtonItemStyleBordered
//                                                                        target:self
//                                                                        action:nil];
//    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(self.stringHeader, nil);
    [self getPlaylist];
    [self.tableView reloadData];
}

- (void) viewDidLayoutSubviews // Layout màn hình theo tỉ lệ 1:2
{
    [super viewWillLayoutSubviews];
    
    
    CGFloat statusNavigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.stringLinkImage]];
    _image.image = [UIImage imageWithData: imageData];
//    _image.frame = CGRectMake(10, statusNavigationBarHeight+10, self.view.bounds.size.width-20, (self.view.bounds.size.height-20)/3
//                              );
//    
//    [self.view addSubview:_image ];
    self.tableView.frame = CGRectMake(10, statusNavigationBarHeight, self.view.bounds.size.width-20, self.view.bounds.size.height-statusNavigationBarHeight);
    
}
-(void) getPlaylist{
    arr_data = nil;
    [[NetworkManager shareManager] GetPlaylistFromLink:self.stringLinkDetail
                                            OnComplete:^(NSArray *items) {
                                                arr_data = [[NSMutableArray alloc] initWithArray:items];
                                                
                                            } fail:^{
                                                NSLog(@"loi");
                                            }];
    
}

#pragma mark - Tableview configure


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.stringHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr_data.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
    if (arr_data.count >0) {
        PhimObj *obj = arr_data[indexPath.row];
        cell.textLabel.text = obj.tenPhim;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.stringLinkImage]];
        cell.imageView.image = [UIImage imageWithData:data]; // Lấy tạm ảnh của frontview
        //        cell.detailTextLabel.text = obj.linkChitiet; //Link của PlayScreen
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    }
    return cell ;}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.PlayScreen) {
        self.PlayScreen = [PlayScreen new];
    }
    
    PhimObj *phim = [ PhimObj new];
    
    phim = arr_data[indexPath.row];
    self.PlayScreen.linkMp3 = phim.linkChitiet;
    _PlayScreen.strImage = _stringLinkImage;
    [self.navigationController presentViewController:_PlayScreen animated:YES completion:nil];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
@end
