//
//  HomePageTableViewDataSource.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "HomePageTableViewDataSource.h"
#import "BarcodeItemStore.h"
#import "BarcodeItem.h"

@interface HomePageTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HomePageTableViewDataSource

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HomePageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    self.tableView = tableView;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageTableViewCell" owner:cell options:nil];
        cell = [nib objectAtIndex:0];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:261];
        UISwitch *switchB = (UISwitch *)[cell viewWithTag:262];
        UILabel *likeLabel = (UILabel *)[cell viewWithTag:263];
        BarcodeItem *item = (BarcodeItem *)[self.items objectAtIndex:indexPath.row];
        
        [switchB addTarget:self action:@selector(switchButtonChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        nameLabel.text = item.itemName;
        switchB.on = item.isLiked;
        likeLabel.text = item.isLiked ? @"YES" : @"NO";
    }
    
    return cell;
}

- (void)switchButtonChangeValue: (id)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UISwitch *switchButton = (UISwitch *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BarcodeItem *item = [self.items objectAtIndex:indexPath.row];
    
    item.isLiked = switchButton.isOn ? YES : NO;
    UILabel *likeLabel = (UILabel *)[cell viewWithTag:263];
    likeLabel.text = item.isLiked ? @"YES" : @"NO";
    NSLog(@"item: %@",item);
}

- (NSArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray arrayWithArray:[[BarcodeItemStore sharedInstance] allItem]];
    }
    return _items;
}

- (void)refreshData
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[[BarcodeItemStore sharedInstance] allItem]];
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    NSLog(@"table view data source dealloc");
}

@end
