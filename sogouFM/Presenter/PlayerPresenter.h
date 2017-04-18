//
//  PlayListPresenter.h
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackPresenter.h"
#import "Track.h"

@protocol  PlayerPresenterDelegate<NSObject>

@required
-(void)playListChanged;
-(void)currentTrackChanged;

@optional
-(void)playerProgressUpdatedWithCurrentTimeText:(NSString*)currentTimeText
                                   durationText:(NSString*)durationText
                                        percent:(double)percent;
@end

@interface PlayerPresenter : NSObject

@property (nonatomic, strong) id<PlayerPresenterDelegate> callback;


-(instancetype)init;
-(instancetype)initWithPlayList:(NSArray*)playList index:(NSInteger)index;


-(void)play;
-(void)pause;
-(void)resume;


-(TrackPresenter*)currentTrackPresenter;

-(void)switchIndex:(NSInteger)index;

-(NSUInteger)trackCount;
-(TrackPresenter*)trackForIndex:(NSInteger)index;


@end
