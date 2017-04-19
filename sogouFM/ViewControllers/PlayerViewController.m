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
#import "ContentServices.h"



@interface PlayerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *Progress;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UITableView *playListTableView;

@property (nonatomic, strong) id<PlayerService> playerService;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSMutableDictionary* nowPlayingInfo;

@property (nonatomic, strong) NSArray<Track*>* playList;
@end


@implementation PlayerViewController

-(id<PlayerService>)playerService {
    if(_playerService == nil){
        _playerService = [PlayerServiceFactory create];
    }
    
    return _playerService;
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.track == nil){
        NSArray* array = [[[ContentServices alloc] init] fetchTracks];
        if(array != nil || array.count > 0){
            self.track = [array firstObject];
        }
        
        self.playList = array;
    
    }
    [self.playerService addDelegate:self];
  
    //[self.playListTableView registerClass:[PlayListTableViewCell class] forCellReuseIdentifier:@"PlayListTableViewCell"];
    self.playListTableView.dataSource = self;
    self.playListTableView.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self playAudio];
    // Do any additional setup after loading the view.
}

-(void) play {
    
    [self.playerService play];
   
    /*
    NSMutableDictionary* nowPlayingInfo = self.nowPlayingInfo;
    
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(1);
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    self.nowPlayingInfo = nowPlayingInfo;
    */
    
}
-(void) pause {
    [self.playerService pause];
    
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    /*if([keyPath isEqualToString: @"duration"]) {
        [self updateCurrentTime: self.playerService.currentTime andDuration:self.player.duration];
    }*/
}


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
}

- (void)displayTrackInfo{
    
    self.titleLabel.text = self.track.title;
    [self.titleLabel sizeToFit];
    self.authorLabel.text = self.track.author.authorName;
    [self.authorLabel sizeToFit];
    
    self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.track.imgUrl]]];
}

- (void) playAudio {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.playerService playWithTrack:self.track];
    
    [self displayTrackInfo];
    
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

#pragma mask UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playList ? self.playList.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PlayListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PlayListTableViewCell" forIndexPath:indexPath];
   
    
    
    if(self.playList == nil || self.playList.count <= indexPath.row ){
        return nil;
    }
    
    Track* track = [self.playList objectAtIndex:indexPath.row];
    cell.titleLabel.text =  track.title;
    cell.authorLabel.text = track.author.authorName;
    cell.coverImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:track.imgUrl]]];
    
    return cell;
}

#pragma mask UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Track* track = [self.playList objectAtIndex:indexPath.row];
    if(track){
        self.track = track;
        [self playAudio];
    }
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
