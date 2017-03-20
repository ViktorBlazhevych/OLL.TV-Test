//
//  Model.m
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"
#import "ItemVO.h"

NSString* const MODEL_DATA_UPDATED = @"MODEL_DATA_UPDATED";

@implementation Model
+ (Model*)sharedInstance
{
    static Model *instanse = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanse = [[self alloc] init];
        instanse.dataArray = [NSMutableArray new];
        instanse.cache = [NSCache new];
    });
    
    return instanse;
}

//

-(NSMutableURLRequest*) createRequest:(int)direction {
    int borderID = 0;
    if([self.dataArray count] == 0) {
        borderID = 0;
    }
    else if (direction == 1){
        borderID = ((ItemVO *)[self.dataArray lastObject]).id;
    }
    else if (direction == -1) {
        borderID = ((ItemVO *)[self.dataArray firstObject]).id;
    }

    NSString *requestParam = [NSString stringWithFormat:@"serial_number=%@&borderId=%i&direction=%i", self.myUUID,borderID, direction];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", API_URL, requestParam];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];

    return request;
}

-(void) loadData:(int)direction {
    NSMutableURLRequest *request  = [self createRequest:(int)direction];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            [self parseResponde:data response:response];
        }
    }];
    [dataTask resume];
}

-(void) parseResponde:(NSData*) data response:(NSURLResponse*)response {
    NSMutableDictionary *respondJSON = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    /*
     items - массив элементов, которые нужно выводить в списке
     items_number - количество элементов в массиве items
     total - общее количество элементов
     offset - количество элементов от начала списка до текущего borderId
     hasMore - количество элементов от borderId до конца списка
     */
    
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:response.URL resolvingAgainstBaseURL:NO];
    int direction = 0;
    int borderID = 0;
    for(NSURLQueryItem *item in urlComponents.queryItems) {
        if([item.name isEqualToString:@"direction"]){
            direction = (int)[item.value integerValue];
        }
        if([item.name isEqualToString:@"borderId"]){
            borderID = (int)[item.value integerValue];
        }
    }

    NSArray *list = respondJSON[@"items"];
    if(list){
        for (id obj in list) {
            ItemVO *item = [ItemVO new];
            item.id = (int)[obj[@"id"] integerValue];
            item.name = obj[@"name"];
            item.icon = obj[@"icon"];
            item.channel_name = obj[@"channel_name"];
            item.start = obj[@"start"];
            item.stop = obj[@"stop"];
            item.descriptionItem = obj[@"description"];
            // отсебячина
            item.videoURL = @"http://cdn.theoplayer.com/video/star_wars_episode_vii-the_force_awakens_official_comic-con_2015_reel_(2015)/index.m3u8";
            //
            if(direction >= 0){
                if(borderID != item.id){
                    [self.dataArray addObject:item];
                }
            }
            else{
                [self.dataArray insertObject:item atIndex:0];
            }
        }
    }
    
    /*
    NSLog(@"items_number - количество элементов в массиве items %@", respondJSON[@"items_number"]);
    NSLog(@"total - общее количество элементов %@", respondJSON[@"total"]);
    NSLog(@"offset - количество элементов от начала списка до текущего borderId %@", respondJSON[@"offset"]);
    NSLog(@"hasMore - количество элементов от borderId до конца списка %@", respondJSON[@"hasMore"]);
    NSLog(@"borderId first %i", ((ItemVO *)[self.dataArray firstObject]).id);
    NSLog(@"borderId last %i", ((ItemVO *)[self.dataArray lastObject]).id);
    */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MODEL_DATA_UPDATED object:nil];
    });
}

@end
