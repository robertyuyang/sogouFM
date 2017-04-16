//
//  DouPlayerService.m
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "DouPlayerService.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DOUAudioStreamer.h"
#import "DOUAudioFile.h"

@interface DouTrack : NSObject <DOUAudioFile>

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *audioFileURL;


@end

@implementation DouTrack


@end


@interface DouPlayerService()

@property (nonatomic, strong) Track* track;
@property (nonatomic, strong) DOUAudioStreamer* douplayer;
@property (nonatomic) dispatch_source_t currentTimeTimer;

@property (nonatomic, strong) id<PlayerServiceDelegate> delegate;

@end

@implementation DouPlayerService



-(Track*)currentTrack {
    return self.track;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if([keyPath isEqualToString: @"duration"]) {
        if(self.delegate){
            [self.delegate PlayerServiceProgressUpdated:[self.douplayer currentTime] duration: self.douplayer.duration];
        }
        
        //[self updateCurrentTime: self.douplayer.currentTime andDuration:self.douplayer.duration];
    }
}

-(void)addDelegate:(id<PlayerServiceDelegate>)delegate {
    self.delegate = delegate;
}


-(void)playWithTrack:(Track*)track {
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.track = track;
    DouTrack* audioFile = [[DouTrack alloc] init];
    audioFile.audioFileURL = [NSURL URLWithString: track.url];
    audioFile.artist = track.author.authorName;
    audioFile.title = track.title;
    self.douplayer = [DOUAudioStreamer streamerWithAudioFile: audioFile];
    
    
    [self.douplayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.douplayer play];
    
    self.currentTimeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.currentTimeTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.currentTimeTimer, ^{
        if(self.delegate){
            [self.delegate PlayerServiceProgressUpdated:[self.douplayer currentTime] duration: self.douplayer.duration];
        }
    });
    dispatch_resume(self.currentTimeTimer);
}

-(void)play{
    [self.douplayer play];
}
-(void)pause{
    [self.douplayer pause];
}
-(void)next {
}
-(void)prev {
}

@end
