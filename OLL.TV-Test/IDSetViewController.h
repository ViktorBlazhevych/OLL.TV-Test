//
//  IDSetViewController.h
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDSetViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *b_getUUID;
@property (weak, nonatomic) IBOutlet UILabel *l_uuid;
@property (weak, nonatomic) IBOutlet UILabel *l_description;

- (IBAction)onGetUUID:(UIButton *)sender;

@end
