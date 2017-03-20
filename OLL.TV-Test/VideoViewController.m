//
//  VideoViewController.m
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Model.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup item data
    self.title = self.item.channel_name;
    self.l_infoChanel.text = [NSString stringWithFormat:@"id channel: %i", self.item.id];
    self.l_name.text = self.item.name;
    self.l_startStop.text = [NSString stringWithFormat:@"Start: %@\nStop: %@", self.item.start, self.item.stop];
    self.l_descriptionItem.text = self.item.descriptionItem;
    NSString *key = [NSString stringWithFormat:@"idImage_%i", (int)self.item.id];
    if ([[Model sharedInstance].cache objectForKey:key] != nil){
        self.icon.image = [[Model sharedInstance].cache objectForKey:key];
    }
    self.bage.hidden = ([self.item.channel_name rangeOfString:@" HD"].location == NSNotFound);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addVideoPlayer];

}

-(void) addVideoPlayer {
    NSURL *videoURL = [NSURL URLWithString:self.item.videoURL];

    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player play];

    [self addChildViewController:controller];
    [self.videoArea addSubview:controller.view];
    controller.view.frame = CGRectMake(0, 0, self.videoArea.frame.size.width, self.videoArea.frame.size.height);
}

@end
