//
//  SettingPageViewController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "SettingPageViewController.h"

@interface SettingPageViewController ()
{
    BOOL _isHD;
}
@property (weak, nonatomic) IBOutlet UISwitch *HDSwitch;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation SettingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _defaults = userDefaults;

    _HDSwitch.on = [_defaults boolForKey:HD_SETTING_KEY];
    _isHD = _HDSwitch.isOn;
    [_defaults setBool:_isHD forKey:HD_SETTING_KEY];
    [_defaults synchronize];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HDSwitch:(id)sender {
    UISwitch *button  = (UISwitch *)sender;
    _isHD = button.on;
    [_defaults setBool:_isHD forKey:HD_SETTING_KEY];
    [_defaults synchronize];
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
