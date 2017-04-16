//
//  ContentServices.m
//  sogouFM
//
//  Created by Robert on 16/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "ContentServices.h"

#import "Track.h"
//#import <MediaPlayer/MediaPlayer.h>

@implementation ContentServices

-(NSArray*) fetchTracks {
    return [[self class] remoteTracks];
}




+ (void)load
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self remoteTracks];
    });
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self musicLibraryTracks];
    });*/
}

+ (NSArray *)remoteTracks
{
    static NSArray *tracks = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://douban.fm/j/mine/playlist?type=n&channel=1004693&from=mainsite"]];
        //NSError* error;
        
        
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://douban.fm/j/mine/playlist?type=n&channel=1&from=mainsite"]];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSMutableArray *allTracks = [NSMutableArray array];
        for (NSDictionary *song in [dict objectForKey:@"song"]) {
            Track *track = [[Track alloc] init];
            Author* author = [[Author alloc] init];
            author.authorName = [song objectForKey:@"artist"];
            [track setTitle:[song objectForKey:@"title"]];
            [track setUrl:[song objectForKey:@"url"]];
            [track setAuthor: author];
            [track setImgUrl:[song objectForKey:@"picture"]];
            
            
            [allTracks addObject:track];
        }
        
        tracks = [allTracks copy];
    });
    
    return tracks;
}
@end
