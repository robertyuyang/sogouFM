//
//  PlayListPresenter.h
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveCocoa.h"
#import "TrackViewModel.h"
#import "Track.h"

/*@protocol  PlayerPresenterDelegate<NSObject>

@required
-(void)playListChanged;
-(void)currentTrackChanged;

@optional
-(void)playerProgressUpdatedWithCurrentTimeText:(NSString*)currentTimeText
                                   durationText:(NSString*)durationText
                                        percent:(double)percent;
@end*/

@interface PlayerViewModel : NSObject

//@property (nonatomic, strong) id<PlayerPresenterDelegate> callback;


/*@property (nonatomic, strong, readonly) RACSignal* playListChangedSignal;
@property (nonatomic, strong, readonly) RACSignal* currentTrackChangedSignal;
@property (nonatomic, strong, readonly) RACSignal* progressUpdatedSignal;
*/

@property (nonatomic, strong, readonly) NSArray* trackViewModels;
@property (nonatomic, strong, readonly) TrackViewModel* currentTrackViewModel;

@property (nonatomic, strong, readonly) RACCommand* playCommand;
@property (nonatomic, strong, readonly) RACCommand* pauseCommand;
@property (nonatomic, strong, readonly) RACCommand* resumeCommand;

@property (nonatomic, strong, readonly) RACCommand* switchTrackCommand;


@property (nonatomic, readonly) double progressPercent;
@property (nonatomic, strong, readonly) NSString* currentTimeText;
@property (nonatomic, strong, readonly) NSString* durationText;


-(instancetype)init;
-(instancetype)initWithPlayList:(NSArray*)playList index:(NSInteger)index;



/*
-(void)play;
-(void)pause;
-(void)resume;
*/

-(TrackViewModel*)currentTrackViewModel;
-(TrackViewModel*)trackViewModelForIndex:(NSInteger)index;

/*
-(void)switchIndex:(NSInteger)index;

-(NSUInteger)trackCount;
-(TrackPresenter*)trackForIndex:(NSInteger)index;
*/

@end
