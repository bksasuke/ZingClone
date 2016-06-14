//
//  FrontViewController.m
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/17/15.
//
//

#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "DetailScreen.h"
#import "DataItems.h"
#import "DataItem.h"
#import "TFHpple.h"
#import "PhimObj.h"
#import "NetworkManager.h"
#import "RearViewController.h"
#import "PlayScreen.h"
@interface FrontViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arr_data;
}
@property (nonatomic, strong) DetailScreen *detailScreen;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, weak) NSString *desLink ;
@property (nonatomic,strong) PlayScreen *PlayScreen;
@property (nonatomic, weak) NSArray *entries;
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation FrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.linkFrontView == nil) {
        
        self.linkFrontView = @"http://mp3.zing.vn/the-loai-album.html";
    }
    if (self.titleHeader == nil) {
        self.titleHeader = @"Album";
    }
    
    else;
    //NSLog(@"%@",self.linkFrontView);
    
    [self loadHTML];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(showPlayingView)];
    [_playView setUserInteractionEnabled:YES];
    [_playView addGestureRecognizer:tap];
    
    // Lazy loading
    self.queue = [[NSOperationQueue alloc]init];
    
}
- (void) viewDidLayoutSubviews // Layout màn hình theo tỉ lệ 1:2
{
    [super viewWillLayoutSubviews];
    [self loadHTML];
    _image.image = [UIImage imageNamed:@"zing2.png"];
    
}

- ( void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    BOOL haveMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"haveMusic"];
    if (haveMusic) {
        [self setUpRemoteView];
    }
}


-(void) loadHTML{
    [[NetworkManager shareManager] GetMusicFromLink:self.linkFrontView
                                         OnComplete:^(NSArray *items) {
                                             arr_data = [[NSMutableArray alloc] initWithArray:items];
                                             
                                             [self.tableView reloadData]; // Tải lại table khi dữ liệu đc parse về.
                                             
                                         } fail:^{
                                             NSLog(@"loi");
                                         }];
    
}
#pragma mark - show now playingview

- ( void) showPlayingView {
    if (!self.PlayScreen) {
        self.PlayScreen = [PlayScreen new];
    }
    
    [self.navigationController presentViewController:_PlayScreen animated:YES completion:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Tableview configure


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return _titleHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //     NSLog(@"%lu",(unsigned long)arr_data.count);
    
    return arr_data.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
    
    PhimObj *obj = arr_data[indexPath.row];
    cell.textLabel.text = obj.tenPhim;
    cell.detailTextLabel.text = obj.theLoai;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    
    if  (!obj.thumbNail)
    {
        dispatch_async (dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.linkAnh]];
            obj.thumbNail =[UIImage imageWithData:data];
            cell.imageView.image = obj.thumbNail;
        });
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
        
        
    }
    else {
        cell.imageView.image = obj.thumbNail;
        
    }
    
    //    cell.textLabel.text = obj.tenPhim;
    //    cell.detailTextLabel.text = obj.theLoai;
    //    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    return cell ;}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.detailScreen) {
        self.detailScreen = [[DetailScreen alloc] init];
    }
    
    PhimObj *phimObj = [PhimObj new];
    phimObj = arr_data[indexPath.row];
    
    // NSLog(@"Push screen to %ld ",(long)indexPath.row);
    
    
    self.detailScreen.stringLinkDetail = phimObj.linkChitiet;
    self.detailScreen.stringLinkImage = phimObj.linkAnh;
    self.detailScreen.stringHeader = phimObj.tenPhim;
    [self.navigationController pushViewController:self.detailScreen animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 80;
//}

#pragma mark - remote View
- ( void)setUpRemoteView  {
    [_playView setHidden:NO];
    
}

- ( void) addRotateDisc {
    UIView *playView = [[UIView alloc]initWithFrame:CGRectMake(3, 2, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"disc"];
    [playView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [_playView addSubview:playView];
    
}
@end

















