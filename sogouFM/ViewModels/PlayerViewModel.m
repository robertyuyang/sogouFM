//
//  PlayListPresenter.m
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "PlayerViewModel.h"
#import "ReactiveCocoa.h"
//#import "RACEXTScope.h"

#import "ContentServices.h"
#import "PlayerServiceFactory.h"

@interface PlayerViewModel()<PlayerServiceDelegate>

@property (nonatomic, strong) NSArray* playList;
@property (nonatomic, strong) Track* currentTrack;

@property (nonatomic, strong) NSMutableDictionary* coverImgDict;

@property (nonatomic, strong) ContentServices* contentService;
@property (nonatomic, strong) id<PlayerService> playerService;




/*@property (nonatomic, strong, readwrite) RACSignal* playListChangedSignal;
@property (nonatomic, strong, readwrite) RACSignal* currentTrackChangedSignal;
@property (nonatomic, strong, readwrite) RACSignal* progressUpdatedSignal;
*/

@property (nonatomic, strong, readwrite) NSArray* trackViewModels;
@property (nonatomic, strong, readwrite) TrackViewModel* currentTrackViewModel;

@property (nonatomic, strong, readwrite) RACCommand* playCommand;
@property (nonatomic, strong, readwrite) RACCommand* pauseCommand;
@property (nonatomic, strong, readwrite) RACCommand* resumeCommand;

@property (nonatomic, strong, readwrite) RACCommand* switchTrackCommand;


@property (nonatomic, readwrite) double progressPercent;
@property (nonatomic, strong, readwrite) NSString* currentTimeText;
@property (nonatomic, strong, readwrite) NSString* durationText;


@end


@implementation PlayerViewModel

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
   
    @weakify(self);
    self.playCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //@strongify(self);
        [self play];
        return [RACSignal empty];
    }];
    
    self.pauseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self pause];
        return [RACSignal empty];
    }];
    self.resumeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self resume];
        return [RACSignal empty];
    }];
    
    self.switchTrackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSInteger index = [input integerValue];
        [self switchIndex:index];
        return [RACSignal empty];
    }];
    
    [RACObserve(self, currentTrack) subscribeNext:^(id x) {
        Track* track = (Track*)x;
        if(track == nil){
            return;
        }
        @strongify(self);
        self.currentTrackViewModel = [[TrackViewModel alloc] initWithTrack:self.currentTrack];
    }];
    
    [RACObserve(self, playList) subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray* viewModels = [[NSMutableArray alloc] initWithCapacity:self.playList.count];
        [self.playList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Track* track = obj;
            TrackViewModel* viewModel = [[TrackViewModel alloc] initWithTrack:track];
            [viewModels addObject:viewModel];
        }];
        self.trackViewModels = [viewModels copy];
    }];
   
    NSArray* tracks = [self.contentService fetchTracks];
    self = [self initWithPlayList:tracks index:0];
    
    return self;
}

-(void)setPlayList:(NSArray*)playList index:(NSInteger)index {
    self.playList = playList;
    if(index >= self.playList.count) {
        index = 0;
    }
    
    self.currentTrack = [self.playList objectAtIndex:index];
    
    
   
}

-(instancetype)initWithPlayList:(NSArray*)playList index:(NSInteger)index {
     self = [super init];
    
    [self setPlayList:playList index:index];
    
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
    
}



/*
-(TrackPresenter*)trackForIndex:(NSInteger)index {
    if(index >= self.playList.count){
        return nil;
    }
    
    Track* track = [self.playList objectAtIndex:index];
    return [[TrackPresenter alloc] initWithTrack:track];
}


-(TrackViewModel*)currentTrackVi {
    if(self.playList.count == 0){
        return nil;
    }
    else{
        return [[TrackPresenter alloc] initWithTrack:[self.playList firstObject]];
    }
    
}*/

-(void)PlayerServiceProgressUpdated:(NSUInteger)currentTime duration:(NSUInteger)duration {
    
    self.progressPercent = duration == 0 ? 0.0 : (double)currentTime / (double)duration;
    
    self.currentTimeText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(currentTime / 60), (NSInteger)currentTime % 60];
    self.durationText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(duration / 60), (NSInteger)duration % 60];
    
    /*if(self.callback){
        if([self.callback respondsToSelector:@selector(playerProgressUpdatedWithCurrentTimeText:durationText:percent:)]){
            
            double percent = duration == 0 ? 0.0 : (double)currentTime / (double)duration;
            
            NSString* currentTimeText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(currentTime / 60), (NSInteger)currentTime % 60];
            NSString* durationText = [NSString stringWithFormat:@"%.2lu:%.2lu", (NSInteger)(duration / 60), (NSInteger)duration % 60];
        
            
            [self.callback playerProgressUpdatedWithCurrentTimeText:currentTimeText durationText:durationText percent:percent];
        }
    }*/
}

@end
