//
//  DataListViewController.m
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#import "DataListViewController.h"
#import "Model.h"
#import "ItemVO.h"
#import "AppDelegate.h"
#import "VideoViewController.h"
#import "HexColors.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "CustomTableViewCell.h"

@interface DataListViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation DataListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Notification for updateModel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataInTable:) name:MODEL_DATA_UPDATED object:nil];

    // set titleView for NavigationBar
    [self.view setBackgroundColor:[UIColor colorWithHexString:COLOR_BLUE]];
    UIImage *image = [[UIImage imageNamed:@"logo_OllTV.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tintColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    imageView.frame = titleView.bounds;
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    // Add UIRefreshControl
    UIRefreshControl *refreshControl  = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.tag = -1;
    [refreshControl addTarget:self action:@selector(onRefreshData:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
   //
    UIRefreshControl *refreshControlBottom = [UIRefreshControl new];
    refreshControlBottom.tintColor = [UIColor lightGrayColor];
    refreshControlBottom.tag = 1;
    refreshControlBottom.triggerVerticalOffset = 100.;
    [refreshControlBottom addTarget:self action:@selector(onRefreshData:) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = refreshControlBottom;
    
    // load Data
    [[Model sharedInstance] loadData:0];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onRefreshData:(id) sender {
    [[Model sharedInstance] loadData:(int)[sender tag]];
}

- (IBAction)onFilterController:(id)sender {
    [self updateDataInTable:nil];
}

-(void) updateDataInTable:(id) sender {
    if([self.tableView.refreshControl isRefreshing]){
        [self.tableView.refreshControl endRefreshing];
    }
    if([self.tableView.bottomRefreshControl isRefreshing]){
        [self.tableView.bottomRefreshControl endRefreshing];
    }
    
    if(self.filterController.selectedSegmentIndex == 0){
        self.itemsArray = [[Model sharedInstance] dataArray];
    }
    else if(self.filterController.selectedSegmentIndex == 1) {
        NSPredicate *filer = [NSPredicate predicateWithFormat:@"NOT (channel_name CONTAINS[c] %@)", @" HD" ];
        self.itemsArray = [[[Model sharedInstance] dataArray] filteredArrayUsingPredicate:filer];
    }
    else if(self.filterController.selectedSegmentIndex == 2) {
        NSPredicate *filer = [NSPredicate predicateWithFormat:@"channel_name CONTAINS[c] %@", @" HD" ];
        self.itemsArray = [[[Model sharedInstance] dataArray] filteredArrayUsingPredicate:filer];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identivicator = @"cellItem";
    CustomTableViewCell* cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identivicator];
    
    ItemVO *item = (ItemVO*)[self.itemsArray objectAtIndex:indexPath.row];
    cell.l_title.text = item.channel_name;
    cell.l_name.text = [NSString stringWithFormat:@"%@", item.name];
    cell.bage.hidden = ([item.channel_name rangeOfString:@" HD"].location == NSNotFound);
    cell.l_startStop.text = item.start;
    // set icon
    cell.icon.image = nil;
    NSString *key = [NSString stringWithFormat:@"idImage_%i", (int)item.id];
    if ([[Model sharedInstance].cache objectForKey:key] != nil){
        cell.icon.image = [[Model sharedInstance].cache objectForKey:key];
    } else{
        [self imageForIndexPath:indexPath];
    }
    return cell;
}

-(void) imageForIndexPath:(NSIndexPath *)indexPath {
    ItemVO *item = (ItemVO*)[self.itemsArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", item.icon]];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                NSString *key = [NSString stringWithFormat:@"idImage_%i", (int)item.id];
                [[Model sharedInstance].cache setObject:image forKey:key];
                dispatch_async(dispatch_get_main_queue(), ^{
                    CustomTableViewCell *updateCell = (CustomTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell){
                        updateCell.icon.image = image;
                        [updateCell layoutSubviews];
                    }
                });
            }
        }
    }];
    [task resume];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VideoViewController *vc = [segue destinationViewController];
    vc.item = (ItemVO*)[self.itemsArray objectAtIndex:[self.tableView indexPathForCell:sender].row];
}

@end
