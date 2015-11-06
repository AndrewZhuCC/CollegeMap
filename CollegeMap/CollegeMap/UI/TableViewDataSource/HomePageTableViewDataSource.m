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

@property (nonatomic, strong) NSArray *items;

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
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageTableViewCell" owner:cell options:nil];
        cell = [nib objectAtIndex:0];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:261];
        UISwitch *switchB = (UISwitch *)[cell viewWithTag:262];
        UILabel *likeLabel = (UILabel *)[cell viewWithTag:263];
        UITextField *textField = (UITextField *)[cell viewWithTag:264];
        BarcodeItem *item = (BarcodeItem *)[self.items objectAtIndex:indexPath.row];
        
        nameLabel.text = item.itemName;
    }
    
    return cell;
}

- (NSArray *)items
{
    if (_items == nil) {
        _items = [[BarcodeItemStore sharedInstance] allItem];
    }
    return _items;
}

@end
