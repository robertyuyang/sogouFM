//
//  ViewController.m
//  sogouFM
//
//  Created by Robert on 13/04/2017.
//  Copyright © 2017 Sogou. All rights reserved.
//

#import "ViewController.h"
#import "ContentServices.h"
#import "PlayerViewController.h"

#import "Track.h"

@interface ViewController ()
@property (nonatomic, strong) ContentServices* contentService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentService = [[ContentServices alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self viewDidLayoutSubviews];
    
    
    
    // Dispose of any resources that can be recreated.
}


- (IBAction)playClick:(id)sender {
    NSArray* array = [self.contentService fetchTracks];
    if(array == nil || array.count == 0){
        return;
    }
    
    Track* track = [array firstObject];
    PlayerViewController* playerVC = [PlayerViewController sharedInstance];
    playerVC.track = track;
    [self presentViewController:playerVC animated:YES completion:nil];
}
@end
