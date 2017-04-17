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
        
        
        
        //NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://douban.fm/j/mine/playlist?type=n&channel=1&from=mainsite"]];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.douban.com/v2/fm/playlist?alt=json&apikey=02646d3fb69a52ff072d47bf23cef8fd&app_name=radio_iphone&channel=10&client=s%3Amobile%7Cy%3AiOS%2010.2%7Cf%3A115%7Cd%3Ab88146214e19b8a8244c9bc0e2789da68955234d%7Ce%3AiPhone7%2C1%7Cm%3Aappstore&douban_udid=b635779c65b816b13b330b68921c0f8edc049590&formats=aac&kbps=128&pt=0.0&type=n&udid=b88146214e19b8a8244c9bc0e2789da68955234d&version=115"]];
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
            [track setDuration:[song objectForKey:@"length"]];
            
            
            [allTracks addObject:track];
        }
        
        tracks = [allTracks copy];
    });
    
    return tracks;
}
@end
