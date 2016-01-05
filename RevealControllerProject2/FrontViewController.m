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
@interface FrontViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) DetailScreen *detailScreen;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, weak) NSString *desLink ;
@end

@implementation FrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.linkFrontView == nil) {
        
   self.linkFrontView = @"http://mp3.zing.vn/the-loai-album.html";
    }
    
    else;
    //NSLog(@"%@",self.linkFrontView);
    
    [self loadHTML];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = NSLocalizedString(@"Zing Radio", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}
- (void) viewDidLayoutSubviews // Layout màn hình theo tỉ lệ 1:2
{
    [super viewWillLayoutSubviews];
    [self loadHTML];
    
    CGFloat statusNavigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
  //  CGRect tableViewRec = CGRectMake(0,statusNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height);
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zing2.png"]];
    image.frame = CGRectMake(10, statusNavigationBarHeight+10, self.view.bounds.size.width-20, (self.view.bounds.size.height-20)/3
                             );
    
    [self.view addSubview:image ];
    self.tableView.frame = CGRectMake(10, (self.view.bounds.size.height-20)/3+10, self.view.bounds.size.width-20, (self.view.bounds.size.height-20)*2/3);
    
}

-(void) loadHTML{
    [[NetworkManager shareManager] GetMusicFromLink:self.linkFrontView
                                        OnComplete:^(NSArray *items) {
        self.arr_data = [[NSMutableArray alloc] initWithArray:items];
        
        [self.tableView reloadData]; // Tải lại table khi dữ liệu đc parse về.
        
    } fail:^{
        NSLog(@"loi");
    }];
    
}


#pragma mark - Tableview configure


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Phim đang chiếu";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSLog(@"%lu",(unsigned long)self.arr_data.count);
    
    return self.arr_data.count;
   

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
   
    PhimObj *obj = self.arr_data[indexPath.row];
    cell.textLabel.text = obj.tenPhim;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.linkAnh]];
    cell.imageView.image = [UIImage imageWithData:data];
    cell.detailTextLabel.text = obj.theLoai;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    return cell ;}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.detailScreen) {
        self.detailScreen = [[DetailScreen alloc] init];
    }
    
    PhimObj *phimObj = [PhimObj new];
    phimObj = self.arr_data[indexPath.row];
    
   // NSLog(@"Push screen to %ld ",(long)indexPath.row);
    
    
    self.detailScreen.stringLinkDetail = phimObj.linkChitiet;
    
    self.detailScreen.stringLinkImage = phimObj.linkAnh;
    self.detailScreen.stringHeader = phimObj.tenPhim;
    [self.navigationController pushViewController:self.detailScreen animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



@end

















