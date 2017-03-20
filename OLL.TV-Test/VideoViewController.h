//
//  VideoViewController.h
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemVO.h"
#import "Bage.h"

@interface VideoViewController : UIViewController
@property (nonatomic, strong) ItemVO *item;
@property (weak, nonatomic) IBOutlet UIView *videoArea;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *l_descriptionItem;
@property (weak, nonatomic) IBOutlet UILabel *l_infoChanel;
@property (weak, nonatomic) IBOutlet UILabel *l_name;
@property (weak, nonatomic) IBOutlet UILabel *l_startStop;
@property (weak, nonatomic) IBOutlet Bage *bage;


@end
