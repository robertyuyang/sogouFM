//
//  PlayerService.h
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Track.h"

@protocol PlayerServiceDelegate <NSObject>

@required

-(void)PlayerServiceProgressUpdated:(NSUInteger)currentTime duration:(NSUInteger)duration;

@end


@protocol PlayerService <NSObject>

@required

-(void)playWithTrack:(Track*)track;

-(Track*)currentTrack;

-(void)addDelegate:(id<PlayerServiceDelegate>)delegate;

-(void)play;
-(void)pause;
-(void)next;
-(void)prev;

@end
