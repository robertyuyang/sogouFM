//
//  PlayerServiceFactory.m
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "PlayerServiceFactory.h"
#import "DouPlayerService.h"

@implementation PlayerServiceFactory

+(id<PlayerService>)create {
    static id<PlayerService> _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DouPlayerService alloc] init];
    });
    return _instance;
}
@end
