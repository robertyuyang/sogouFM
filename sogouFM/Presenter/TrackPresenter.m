//
//  TrackPresenter.m
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "TrackPresenter.h"

@interface TrackPresenter()

@property (nonatomic, strong) Track* track;
@property (nonatomic, strong) UIImage* coverImage;
@end

@implementation TrackPresenter

-(instancetype)initWithTrack:(Track*)track {
    self = [super init];
    self.track = track;
    self.coverImage = nil;
    return self;
}


-(NSString*)trackTitle {
    return self.track.title;
}
-(NSString*)trackAuthorName {
    return self.track.author.authorName;
}
-(UIImage*)trackImage {
    if(self.coverImage){
        return _coverImage;
    }
    
    if(self.track.imgUrl == nil || self.track.imgUrl.length == 0){
        return [UIImage imageNamed:@"default"];
    }
    
    self.coverImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.track.imgUrl]]];
    return self.coverImage;
}

@end
