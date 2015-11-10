//
//  HomePageViewController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewDataSource.h"
#import "AZAlertView.h"
#import "TYAlertController.h"
#import "BarcodeItemStore.h"
#import "TYAlertController+BlurEffects.h"

@interface HomePageViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ItemListTableVIew;
@property (nonatomic, strong) HomePageTableViewDataSource *tableViewDatasource;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHomePageTableViewDatasource];
    self.title = @"历史记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"table view refresh");
    [self.tableViewDatasource refreshData];
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AZAlertView *azView = [[AZAlertView alloc]initWithTY:self andFrame:CGRectMake(0, 0, 300, 300)];
    
    BarcodeItem *item = [[BarcodeItemStore sharedInstance] itemAtIndex:indexPath.row];
    [azView showPopUpPreView:item dataSource:self.tableViewDatasource];
    
    TYAlertController *tyController = [TYAlertController alertControllerWithAlertView:azView preferredStyle:TYAlertControllerStyleAlert];
    
    [tyController setBlurEffectWithView:self.view];
    
    [self presentViewController:tyController animated:YES completion:nil];
}

#pragma mark - TableVIewDatasource

- (void)setupHomePageTableViewDatasource
{
    HomePageTableViewDataSource *tableViewDataSource = [[HomePageTableViewDataSource alloc] init];
    self.tableViewDatasource = tableViewDataSource;
    [self.ItemListTableVIew setDataSource:(id<UITableViewDataSource>)tableViewDataSource];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
