//
//  HomePageTableViewDataSource.h
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewDataSource : NSObject <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshData;

@end
