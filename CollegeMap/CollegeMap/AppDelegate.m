//
//  AppDelegate.m
//  CollegeMap
//
//  Created by Andrew on 15/11/2.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "SettingPageViewController.h"
#import "CYLTabBar.h"
#import "AZNavigationController.h"

@interface AppDelegate ()

@property (nonatomic, strong) CYLTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupViewControllers];
    
    [self.window setRootViewController:self.tabBarController];
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return YES;	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground		:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CYLTabBar

- (void)setupViewControllers
{
    HomePageViewController *homePageViewController    = [[HomePageViewController alloc] init];
    AZNavigationController *firstNavigationController = [[AZNavigationController alloc] initWithRootViewController:homePageViewController];
    
    SettingPageViewController *settingPageViewController = [[SettingPageViewController alloc] init];
    AZNavigationController *secondNavigationController   = [[AZNavigationController alloc] initWithRootViewController:settingPageViewController];
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    /**
     *  将一个包含所有不超过5个viewControllers的数组传给tabBarController，设置tabbar控制的子viewController
     */
    [tabBarController setViewControllers:@[
                                          firstNavigationController,
                                          secondNavigationController
                                          ]];
    
    self.tabBarController = tabBarController;
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBatController
{
    /**
     *  每个子viewController对应一个dictionary
     */
    NSDictionary *dic1 = @{
                           CYLTabBarItemTitle : @"Home"
                           };
    
    NSDictionary *dic2 = @{
                           CYLTabBarItemTitle : @"Setting"
                           };
    
    /**
     *  在此传入第二个数组，包含viewController的title,iamge,selectedImage
     */
    NSArray *tabBarItemsAttributes = @[ dic1, dic2];
    tabBatController.tabBarItemsAttributes = tabBarItemsAttributes;
}


@end
