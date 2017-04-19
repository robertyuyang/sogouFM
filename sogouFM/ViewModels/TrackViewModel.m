//
//  TrackPresenter.m
//  sogouFM
//
//  Created by Robert on 17/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "TrackViewModel.h"
#import "ReactiveCocoa.h"
//#import "RACEXTScope.h"


@interface TrackViewModel()

@property (nonatomic, strong) Track* track;
@property (nonatomic, strong) UIImage* coverImage;
@end

@implementation TrackViewModel

-(instancetype)initWithTrack:(Track*)track {
    self = [super init];
    self.track = track;
    self.title = self.track.title;
    self.authorName = self.track.author.authorName;
    self.coverImage = nil;
    self.imgUrl = self.track.imgUrl;
   
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @strongify(self);
        //NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.track.imgUrl]];
        UIImage* coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.track.imgUrl]]];
       
        if(coverImage == nil){
            NSLog(@"00000000");
        }
        else {
            NSLog(@"11111111");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImg = coverImage;
        });
    });
    
    return self;
}

/*
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
}*/

@end
