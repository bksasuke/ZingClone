//
//  PlayScreen.m
//  FunnyFood
//
//  Created by hoangdangtrung on 10/23/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import "PlayScreen.h"
#import "DetailScreen.h"
#import "NetworkManager.h"
#import "PhimObj.h"
@import AVFoundation;


@interface PlayScreen ()

@property (weak, nonatomic) IBOutlet UILabel *labelTimeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arr_data,*arr_data2;
@end

@implementation PlayScreen {
    NSString *stringLinkPlay;
    CABasicAnimation *rotate;
}

UIImageView *animationSpeakerImage;
UIActivityIndicatorView *activityView;
BOOL isPaused;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    
    [self.view reloadInputViews];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveMusic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
- (void ) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_linkMp3) {
        if (_linkMp3 == _currentLinkMp3 ) {
        }
        [self setUpandPlay];
        [self configSeesion];
        
    }
}
- ( void) setUpandPlay {
    [self getXml];
    [self getMp3];
    [self createActivityIndicatorView];
    [self enableButtonPlayStopSlider:NO];
    [self setRotateImage];
    
}

- ( void) setRotateImage{
    
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    rotate.duration = 40;
    rotate.repeatCount = 1e100;
    
    _imgPlay.layer.cornerRadius = _imgPlay.frame.size.width/2;
    UIGraphicsBeginImageContext(self.view.frame.size);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.strImage]];
    image = [UIImage imageWithData:data];
    _imgPlay.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Replace default slider
    
    UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill=="]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-cap"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
}

-(void) getXml{ // step 1 : trả về mảng các đối tượng có link XML
    [[NetworkManager shareManager] GetXmlFromDetailLink:self.linkMp3
                                             OnComplete:^(NSArray *items) {
                                                 self.arr_data = [[NSMutableArray alloc] initWithArray:items];
                                                 
                                             } fail:^{
                                                 NSLog(@"loi");
                                             }];
    _currentLinkMp3 = _linkMp3;
    
}
-(void) getMp3 { //step 2: Trả về các đối tượng có link MP3 tu cac doi tuong xml
    [[NetworkManager shareManager] GetMp3FromXml:self.arr_data[0]
                                      OnComplete:^(NSArray *item2s) {
                                          self.arr_data2 = [[NSMutableArray alloc] initWithArray:item2s];
                                          //                                                 NSLog(@"x %@", self.arr_data2);
                                          PhimObj *song; // Tạm thời đặt hàm play nhạc ở đây vì chưa đưa biến trả về ra global đc.
                                          song = self.arr_data2[0];
                                          stringLinkPlay = song.tenPhim;
                                          if (stringLinkPlay) {
                                              [self.player pause];
                                              [self setupAVPlayerWithURL:stringLinkPlay];
                                              [self.player.currentItem addObserver:self forKeyPath:@"status"
                                                                           options:NSKeyValueObservingOptionNew
                                                                           context:nil]; }
                                          [[NSUserDefaults standardUserDefaults] setObject:stringLinkPlay   forKey:@"currentLink"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      } fail:^{
                                          NSLog(@"loi");
                                      }];
}

#pragma mark Imported file from TrungHD


- (void)viewDidAppear:(BOOL)animated {
    ;
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishPlayer:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
    [self configSeesion];
}

- (void) configSeesion {
    NSError *myErr;
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        //        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
}

/* Setup AVPlayer to play stream audio URL */
- (void)setupAVPlayerWithURL: (NSString*)stringURL {
    NSURL *url = [NSURL URLWithString:stringURL];
    if (_player != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.player.currentItem];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    self.player = [[AVPlayer alloc] initWithURL:url];
    self.sliderShowCurrentTime.value = 0.0;
    self.sliderShowCurrentTime.maximumValue = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    
    self.labelTimeElapsed.text = @"0:00";
    self.labelTimeDuration.text = [NSString stringWithFormat:@"-%@", [self timeFormat:CMTimeGetSeconds(self.player.currentItem.asset.duration)]];
    //    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if (object == self.player.currentItem && [keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayer Ready To Play");
            
            [activityView stopAnimating];
            [self enableButtonPlayStopSlider:YES];
            [self.player play];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(getCurrentTimeAVPlayer)
                                                    userInfo:nil
                                                     repeats:YES];
            [_imgPlay.layer addAnimation:rotate forKey:@"360"];
            [animationSpeakerImage startAnimating];
            [self.btnPlayPause setImage:[UIImage imageNamed:@"pause"]
                               forState:UIControlStateNormal];
            [self.player play];
            isPaused = false;
            
            
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"AVPlayer Failed");
            [self enableButtonPlayStopSlider:NO];
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            [activityView startAnimating];
            [self enableButtonPlayStopSlider:NO];
        }
    }
}

/* Play/Pause */
- (IBAction)btnPlayPause:(id)sender {
    [self.timer invalidate];
    _timer = nil;
    //
    //    CABasicAnimation *rotate;
    //    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    rotate.fromValue = [NSNumber numberWithFloat:0];
    //    rotate.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    //    rotate.duration = 40;
    //    rotate.repeatCount = 1e100;
    [_imgPlay.layer addAnimation:rotate forKey:@"360"];
    
    if(isPaused) {
        NSLog(@"Play");
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(getCurrentTimeAVPlayer)
                                                userInfo:nil
                                                 repeats:YES];
        [animationSpeakerImage startAnimating];
        [self.btnPlayPause setImage:[UIImage imageNamed:@"pause"]
                           forState:UIControlStateNormal];
        [self.player play];
        isPaused = false;
    } else {
        NSLog(@"Pause");
        [animationSpeakerImage stopAnimating];
        [self.btnPlayPause setImage:[UIImage imageNamed:@"play"]
                           forState:UIControlStateNormal];
        [self.player pause];
        isPaused = true;
        [_imgPlay.layer removeAnimationForKey:@"360"];
    }
    
}

/* AVPlayer get current time */
- (void) getCurrentTimeAVPlayer {
    AVPlayerItem *currentItem = self.player.currentItem;
    CMTime duration = currentItem.asset.duration;
    CMTime currentTime = currentItem.currentTime;
    
    self.sliderShowCurrentTime.value = CMTimeGetSeconds(currentTime);
    
    self.labelTimeElapsed.text = [NSString stringWithFormat:@"%@",[self timeFormat:CMTimeGetSeconds(currentTime)]];
    
    self.labelTimeDuration.text = [NSString stringWithFormat:@"-%@", [self timeFormat:CMTimeGetSeconds(duration) - CMTimeGetSeconds(currentTime)]];
    
}

/* Stop */
- (IBAction)btnStopAudioPlayer:(id)sender {
    NSLog(@"Stop");
    [animationSpeakerImage stopAnimating];
    
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    
    self.sliderShowCurrentTime.value = 0;
    self.labelTimeElapsed.text = @"0:00";
    self.labelTimeDuration.text = [NSString stringWithFormat:@"-%@", [self timeFormat:CMTimeGetSeconds(self.player.currentItem.duration)]];
    [self.btnPlayPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    isPaused = true;
    
    [_timer invalidate];
    _timer=nil;
}

/* Slider value changed */
- (IBAction)valueChanged:(id)sender {
    [_timer invalidate];
    _timer = nil;
    
    [self.player pause];
    isPaused = true;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getCurrentTimeAVPlayer) userInfo:nil repeats:NO];
    
    [self.btnPlayPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [animationSpeakerImage stopAnimating];
    
    float timeInSecond = self.sliderShowCurrentTime.value;
    CMTime cmTime = CMTimeMake(timeInSecond, 1);
    [self.player seekToTime:cmTime];
}

/* Convert time (75s -> 1:15) */
- (NSString*)timeFormat: (float)time {
    int minutes = time/60;
    int seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%@%d:%@%d", minutes/10 ? [NSString stringWithFormat:@"%d",minutes/10] : @"", minutes%10, [NSString stringWithFormat:@"%d", seconds/10], seconds%10];
}

/* Create animation image: Speaker */
- (void)createAnimationSpeakerImage {
    CGSize mainViewSize = self.view.bounds.size;
    NSArray *imageSpeaker = @[@"Speaker0", @"Speaker1"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageSpeaker.count; i++) {
        [images addObject:[UIImage imageNamed:[imageSpeaker objectAtIndex:i]]];
    }
    animationSpeakerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainViewSize.width-40, (mainViewSize.width-40)/0.68)];
    animationSpeakerImage.image = [UIImage imageNamed:@"Speaker0"];
    animationSpeakerImage.center = CGPointMake(mainViewSize.width/2, mainViewSize.height/2-40);
    animationSpeakerImage.animationImages = images;
    animationSpeakerImage.animationDuration = 0.3;
    [self.view addSubview:animationSpeakerImage];
}

/* Add Activity Indicator View (loading icon) */
- (void)createActivityIndicatorView {
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    activityView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 + 40);
    [self.view addSubview:activityView];
    [activityView startAnimating];
}

/* Enable/Disable button Play/Pause, Stop, Slider */
- (void)enableButtonPlayStopSlider: (BOOL) yesOrNo {
    [self.btnPlayPause setEnabled:yesOrNo];
    [self.btnStop setEnabled:yesOrNo];
    [self.sliderShowCurrentTime setEnabled:yesOrNo];
}

/* Use Notification get event: AVPlayer item did play to end */
- (void)finishPlayer: (NSNotification*)notification {
    [_timer invalidate];
    _timer = nil;
    [self.btnPlayPause setImage:[UIImage imageNamed:@"play"]
                       forState:UIControlStateNormal];
    NSLog(@"Finish");
    
    [animationSpeakerImage stopAnimating];
    
    self.sliderShowCurrentTime.value = 0;
    
    [self.player seekToTime:kCMTimeZero];
    
    isPaused = true;
}

/* dellocated */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:self.player.currentItem];
    [self.player.currentItem removeObserver:self
                                 forKeyPath:@"status"];
}

- (IBAction)btnHideplay:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

