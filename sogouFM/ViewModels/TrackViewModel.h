//
//  TrackPresenter.h
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface TrackViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* authorName;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) UIImage* coverImg;

-(instancetype)initWithTrack:(Track*)track;

/*-(NSString*)trackTitle;
-(NSString*)trackAuthorName;
-(UIImage*)trackImage;*/
@end
