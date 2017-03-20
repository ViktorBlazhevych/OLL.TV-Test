//
//  Model.h
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const MODEL_DATA_UPDATED;

@interface Model : NSObject

@property (nonatomic, strong) NSUUID *myUUID;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  NSCache *cache;

+ (Model*)sharedInstance;

-(void) loadData:(int) direction;

@end
