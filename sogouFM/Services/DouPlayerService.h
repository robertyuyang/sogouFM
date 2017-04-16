//
//  DouPlayerService.h
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "PlayerService.h"

@interface DouPlayerService : NSObject  <PlayerService>


-(void)playWithTrack:(Track*)track;

-(Track*)currentTrack;

-(void)addDelegate:(id<PlayerServiceDelegate>)delegate;

-(void)play;
-(void)pause;
-(void)next;
-(void)prev;

@end
