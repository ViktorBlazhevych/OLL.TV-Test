//
//  IDSetViewController.m
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import "IDSetViewController.h"
#import "Model.h"

@interface IDSetViewController ()

@end

@implementation IDSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.l_uuid.alpha = 0;
    self.l_description.text = @"Press button for get your UUID and load data.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onGetUUID:(UIButton *)sender {
    NSUUID *deviceID = [[UIDevice currentDevice] identifierForVendor];
    [Model sharedInstance].myUUID = deviceID;
    self.l_uuid.text = [NSString stringWithFormat:@"Your UUID:\n%@",  [[Model sharedInstance].myUUID UUIDString]];
    [self runGroupAnimmation];
}

-(void) runGroupAnimmation {
    [self.view layoutIfNeeded];
    self.groupTopConstraint.constant -=30;
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
        self.b_getUUID.alpha = 0;
        self.l_uuid.alpha = 1;
        
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"s_showTableData" sender:nil];
        });
    } ];
}
@end
