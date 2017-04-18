//
//  TrackPresenter.h
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface TrackPresenter : NSObject


-(instancetype)initWithTrack:(Track*)track;

-(NSString*)trackTitle;
-(NSString*)trackAuthorName;
-(UIImage*)trackImage;
@end
