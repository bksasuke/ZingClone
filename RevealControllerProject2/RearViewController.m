/*
 
 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "RearViewController.h"

#import "SWRevealViewController.h"
#import "FrontViewController.h"


@interface RearViewController()
{
    NSInteger _presentedRow;
    FrontViewController *frontViewController;
}
@property (nonatomic, weak) NSString *desLink;
@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // We determine whether we have a grand parent SWRevealViewController, this means we are at least one level behind the hierarchy
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:grandParentRevealController
                                                                        action:@selector(revealToggle:)];
    
    SWRevealViewController *revealController = self.revealViewController;
    
    
    UIViewController *newFrontController = nil;
    frontViewController = [[FrontViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    self.desLink = nil;
    self.navigationItem.title = @"List Chanel";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = NO;
    [frontViewController.view setUserInteractionEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = YES;
    [frontViewController.view setUserInteractionEnabled:YES];
}


#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSString *text = nil;
    UIImage *cellImage;
    if (row == 0)
    {
        text = @"Hot Music";
        cellImage = [UIImage imageNamed:@"1.jpg"];
        
    }
    else if (row == 1)
    {
        text = @"Album";
        cellImage = [UIImage imageNamed:@"2.jpg"];
    }
    else if (row == 2)
    {
        text = @"Nghệ sĩ";
        cellImage = [UIImage imageNamed:@"3.jpg"];
        
    }
    else if (row == 3)
    {
        text = @"BXH";
        cellImage = [UIImage imageNamed:@"4.jpg"];
        
    }
    else if (row == 4)
    {
        text = @"Top 100";
        cellImage = [UIImage imageNamed:@"5.jpg"];
        
    }
    
    cell.textLabel.text = NSLocalizedString( text, nil );
    cell.imageView.image = cellImage;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SWRevealViewController *revealController = self.revealViewController;
    
    
    NSInteger row = indexPath.row;
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    
    // otherwise we'll create a new frontViewController and push it with animation
    
    UIViewController *newFrontController = nil;
    newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    if (row == 0) // Tạo các Controller mới tương ứng.
    {
        frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        frontViewController.linkFrontView = @"http://mp3.zing.vn/the-loai-album.html";
        frontViewController.titleHeader = @"Hot Music";
    }
    
    else if (row == 1)
    {
        frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        frontViewController.titleHeader = @"Hot Music";
        frontViewController.linkFrontView = @"http://mp3.zing.vn/the-loai-video.html";
    }
    else if (row == 2)
    {
        frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        frontViewController.linkFrontView = @"http://mp3.zing.vn/the-loai-album/Han-Quoc/IWZ9Z08W.html";
        frontViewController.titleHeader = @"Hot Music";
    }
    else if (row == 3)
    {
        frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        frontViewController.linkFrontView =@"http://mp3.zing.vn/the-loai-album/Au-My/IWZ9Z08O.html";
        frontViewController.titleHeader = @"Hot Music";
    }
    
    else if ( row == 4 )
    {
        frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        frontViewController.linkFrontView =@"http://mp3.zing.vn/the-loai-album/Han-Quoc/IWZ9Z08W.html";
        frontViewController.titleHeader = @"Hot Music";
    }
    
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
}



@end