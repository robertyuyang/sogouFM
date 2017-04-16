//
//  Track.h
//  MyFM
//
//  Created by mac on 10/28/16.
//  Copyright © 2016 BEIJING. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"

@interface Track : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) Author* author;
@property (nonatomic, strong) NSString* url;
@property (nonatomic) NSUInteger duration;
@property (nonatomic) NSString* imgUrl;

-(instancetype) initWithJSONString: (NSString*) jsonString;
@end
