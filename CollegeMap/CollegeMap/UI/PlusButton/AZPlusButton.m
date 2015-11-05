//
//  AZPlusButton.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZPlusButton.h"
#import "ScanViewController.h"
#import "AZNavigationController.h"

@implementation AZPlusButton

+(void)load {
    [super registerSubclass];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 0.6;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

+ (instancetype)plusButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];
//    UIImage *highlightImage = [UIImage imageNamed:@"hood-selected.png"];

    AZPlusButton* button = [AZPlusButton buttonWithType:UIButtonTypeCustom];

    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark - Event Response

- (void)clickPublish {
    
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    AZNavigationController *navigationController = [[AZNavigationController alloc] initWithRootViewController:scanVC];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

    [tabBarController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - CYLPlusButtonSubclassing
+ (CGFloat)multiplerInCenterY {
    return  0.3;
}

@end
