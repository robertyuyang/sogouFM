//
//  PlayerServiceFactory.h
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerService.h"


@interface PlayerServiceFactory : NSObject


+(id<PlayerService>)create;
@end
