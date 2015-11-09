//
//  AZNavigationController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZNavigationController.h"
#import "UIImage+ImageScale.h"

@interface AZNavigationController ()

@end

@implementation AZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setOpaque:YES];
    [self.navigationBar setTranslucent:NO];
    
    CGSize size = CGSizeMake(self.navigationBar.frame.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationBar.frame.size.height );
    UIImage *image = [[UIImage imageNamed:@"Title_BG"] changeSizeToSize:size];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
