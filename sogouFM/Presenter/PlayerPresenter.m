//
//  PlayListPresenter.m
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "PlayerPresenter.h"

#import "ContentServices.h"
#import "PlayerServiceFactory.h"

@interface PlayerPresenter()<PlayerServiceDelegate>

@property (nonatomic, strong) NSArray* playList;
@property (nonatomic, strong) Track* currentTrack;

@property (nonatomic, strong) NSMutableDictionary* coverImgDict;

@property (nonatomic, strong) ContentServices* contentService;
@property (nonatomic, strong) id<PlayerService> playerService;

@end


@implementation PlayerPresenter

-(NSMutableDictionary*)coverImgDict {
    if(_coverImgDict == nil){
        _coverImgDict = [[NSMutableDictionary alloc] init];
    }
    return _coverImgDict;
}


-(instancetype)init {
    self.contentService = [[ContentServices alloc] init];
    self.playerService = [PlayerServiceFactory create];
    
    [self.playerService addDelegate:self];
    
    NSArray* tracks = [self.contentService fetchTracks];
    self = [self initWithPlayList:tracks index:0];
    return self;
}

-(instancetype)initWithPlayList:(NSArray*)playList index:(NSInteger)index {
     self = [super init];
    
    self.playList = playList;
    if(index >= self.playList.count) {
        index = 0;
    }
    
    self.currentTrack = [self.playList objectAtIndex:index];
    
    return self;
}

-(void)play {
    [self.playerService playWithTrack: self.currentTrack];
}
-(void)resume {
    [self.playerService play];
}
-(void)pause {
    [self.playerService pause];
}

/*
-(NSString*)currentTrackTitle {
    return self.currentTrack ? self.currentTrack.title : @"";
}
-(NSString*)currentTrackAuthorName {
    return self.currentTrack ?  self.currentTrack.author.authorName : @"";
}

-(UIImage*)currentTrackCoverImg {
    if(self.currentTrack == nil){
        return nil;
    }
    
    UIImage* image = [self.coverImgDict objectForKey:self.currentTrack.sid];
    if(image){
        return image;
    }
    else{
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentTrack.imgUrl]]];
        return image;
    }
}*/




-(void)switchIndex:(NSInteger)index {
    if(index >= self.playList.count){
        return;
    }
    
    self.currentTrack = [self.playList objectAtIndex:index];
    
    if(self.callback){
        [self.callback currentTrackChanged];
    }
}



-(NSUInteger)trackCount {
    return self.playList ? self.playList.count : 0;
}
-(TrackPresenter*)trackForIndex:(NSInteger)index {
    if(index >= self.playList.count){
        return nil;
    }
    
    Track* track = [self.playList objectAtIndex:index];
    return [[TrackPresenter alloc] initWithTrack:track];
}


-(TrackPresenter*)currentTrackPresenter {
    if(self.playList.count == 0){
        return nil;
    }
    else{
        return [[TrackPresenter alloc] initWithTrack:self.currentTrack];
    }
    
}

-(void)PlayerServiceProgressUpdated:(NSUInteger)currentTime duration:(NSUInteger)duration {
    if(self.callback){
        if([self.callback respondsToSelector:@selector(playerProgressUpdatedWithCurrentTimeText:durationText:percent:)]){
            
            double percent = duration == 0 ? 0.0 : (double)currentTime / (double)duration;
            
            NSString* currentTimeText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(currentTime / 60), (NSInteger)currentTime % 60];
            NSString* durationText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(duration / 60), (NSInteger)duration % 60];
        
            
            [self.callback playerProgressUpdatedWithCurrentTimeText:currentTimeText durationText:durationText percent:percent];
        }
    }
}

@end
