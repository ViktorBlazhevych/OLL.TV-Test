//
//  ItemVO.h
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemVO : NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *descriptionItem;
@property (nonatomic, strong) NSString *channel_name;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *stop;

@property (nonatomic, strong) NSString *videoURL;

@end
