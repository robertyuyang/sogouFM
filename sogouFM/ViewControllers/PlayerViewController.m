//
//  PlayerViewController.m
//  sogouFM
//
//  Created by Robert on 14/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "PlayerViewController.h"
#import <UIKit/UIkit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PlayListTableViewCell.h"

#import "PlayerServiceFactory.h"

#import "PlayerViewModel.h"

#import "ReactiveCocoa.h"



@interface PlayerViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *Progress;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UITableView *playListTableView;

//@property (nonatomic, strong) id<PlayerService> playerService;
//@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSMutableDictionary* nowPlayingInfo;

//@property (nonatomic, strong) NSArray<Track*>* playList;
@property (nonatomic, strong) PlayerViewModel* playerViewModel;
@end


@implementation PlayerViewController

/*-(id<PlayerService>)playerService {
    if(_playerService == nil){
        _playerService = [PlayerServiceFactory create];
    }
    
    return _playerService;
}*/

+(PlayerViewController*) sharedInstance {
    static PlayerViewController* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        PlayerViewController* trackPlayVC = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        instance = trackPlayVC;
    });
    return instance;
}


-(void)setNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo {
    _nowPlayingInfo = nowPlayingInfo;
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}


- (void)initViewModel {
    
    self.playerViewModel = [[PlayerViewModel alloc] init];
    
    @weakify(self);
    [RACObserve(self.playerViewModel, trackViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.playListTableView reloadData];
    }];
   
    RAC(self.titleLabel, text) = RACObserve(self.playerViewModel, currentTrackViewModel.title);
    RAC(self.authorLabel, text) = RACObserve(self.playerViewModel, currentTrackViewModel.authorName);
    /*[RACObserve(self.playerViewModel, currentTrackViewModel.coverImg) subscribeNext:^(id x) {
        @strongify(self);
    }];*/
    
    RAC(self.imageView, image) = RACObserve(self.playerViewModel, currentTrackViewModel.coverImg);

    RAC(self.currentTimeLabel, text) = RACObserve(self.playerViewModel, currentTimeText);
    RAC(self.durationLabel, text) = RACObserve(self.playerViewModel, durationText);
    RAC(self.Progress, value) = RACObserve(self.playerViewModel, progressPercent);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initViewModel];
    
    //[self.playListTableView registerClass:[PlayListTableViewCell class] forCellReuseIdentifier:@"PlayListTableViewCell"];
    self.playListTableView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self playAudio];
    // Do any additional setup after loading the view.
}

-(void) play {
   
    [self.playerViewModel.resumeCommand execute:nil];
    //[self.playerPresenter resume];
    //[self.playerService play];
   
    /*
    NSMutableDictionary* nowPlayingInfo = self.nowPlayingInfo;
    
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(1);
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    self.nowPlayingInfo = nowPlayingInfo;
    */
    
}
-(void) pause {
    [self.playerViewModel.pauseCommand execute:nil];
    
    NSMutableDictionary* nowPlayingInfo = self.nowPlayingInfo;
    
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(0);
    //nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.playerService.currentTime);
    self.nowPlayingInfo = nowPlayingInfo;
}
-(void) stop {
    
}
-(void) next {
    
}

- (IBAction)onPlayClick:(UIButton *)sender {
    [self play];
}
- (IBAction)onPauseClick:(UIButton *)sender {
    [self pause];
}


/*
-(void)updateProgressBar: (NSTimeInterval) currentTime
             andDuration:(NSTimeInterval) duration {
    self.Progress.maximumValue = 1;
    self.Progress.minimumValue = 0;
    self.Progress.value = duration == 0 ? 0 : currentTime / duration;
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(currentTime / 60), (NSInteger)currentTime % 60];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(duration / 60), (NSInteger)duration % 60];
}


-(void)PlayerServiceProgressUpdated:(NSUInteger)currentTime duration:(NSUInteger)duration {
    [self updateCurrentTime:currentTime andDuration:duration];
}
-(void)updateCurrentTime: (NSTimeInterval) currentTime
             andDuration:(NSTimeInterval) duration {
    
    [self updateProgressBar: currentTime andDuration:duration];
    
    NSMutableDictionary* nowPlayingInfo = self.nowPlayingInfo;
    //nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = @(currentTime / duration);
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(duration);
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(currentTime);
    self.nowPlayingInfo = nowPlayingInfo;
    
    NSLog(@"%lf/%lf", currentTime, duration);
}*/

- (void) playAudio {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.playerViewModel.playCommand execute:nil];
  
    /*
    TrackPresenter* trackPresenter = [self.playerPresenter currentTrackPresenter];
    self.titleLabel.text = [trackPresenter trackTitle];
    //self.titleLabel.text = self.track.title;
    [self.titleLabel sizeToFit];
    self.authorLabel.text = [trackPresenter trackAuthorName];
    //self.authorLabel.text = self.track.author.authorName;
    [self.authorLabel sizeToFit];
    //self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.track.imgUrl]]];
    self.imageView.image = [trackPresenter trackImage];
    
    */
    
    
    
    //[self.playerService addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    
    
    /*self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer *timer) {
        [self updateProgressBar:self.playerService.currentTime andDuration:self.player.duration];
    }
                  ];
    
    
    self.nowPlayingInfo =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.track.title,MPMediaItemPropertyTitle,
     self.track.author.authorName,MPMediaItemPropertyArtist,
     @(1),MPNowPlayingInfoPropertyPlaybackRate,
     [[MPMediaItemArtwork alloc]initWithImage:self.imageView.image],
     MPMediaItemPropertyArtwork,
     nil];*/
    
    
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*#pragma mask  PlayerPresenterDelegate

-(void)playListChanged {
    [self.playListTableView reloadData];
}
-(void)currentTrackChanged {
    
}

-(void)playerProgressUpdatedWithCurrentTimeText:(NSString*)currentTimeText
                                   durationText:(NSString*)durationText
                                        percent:(double)percent {
    
    self.Progress.maximumValue = 1;
    self.Progress.minimumValue = 0;
    self.Progress.value = percent;
    
    self.currentTimeLabel.text = currentTimeText;
    self.durationLabel.text = durationText;
}*/


#pragma mask UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(self.playerViewModel == nil || self.playerViewModel.trackViewModels == nil){
        return 0;
    }
    return self.playerViewModel.trackViewModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PlayListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PlayListTableViewCell" forIndexPath:indexPath];
   
    if(self.playerViewModel == nil){
        return nil;
    }
    if(self.playerViewModel.trackViewModels.count <= indexPath.row){
        return nil;
    }
    
    TrackViewModel* trackViewModel = [self.playerViewModel.trackViewModels objectAtIndex:indexPath.row];
   
    cell.titleLabel.text = trackViewModel.title;
    cell.authorLabel.text = trackViewModel.authorName;
    
   
    
    if(cell.coverImageDispose != nil){
        [cell.coverImageDispose dispose];
    }
    cell.coverImageDispose = [RACObserve(trackViewModel, coverImg) subscribeNext:^(id x) {
        if(x != nil){
            cell.coverImageView.image = (UIImage*)x;
        }
    }];
  
    //[RAC(cell.imageView, image) dispose];
    //RAC(cell.imageView, image) = RACObserve(trackViewModel, coverImg);
    
    /*Track* track = [self.playList objectAtIndex:indexPath.row];
    cell.titleLabel.text =  track.title;
    cell.authorLabel.text = track.author.authorName;
    cell.coverImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:track.imgUrl]]];*/
    
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
