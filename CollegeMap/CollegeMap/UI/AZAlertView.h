//
//  AZAlertViewController.h
//  CollegeMap
//
//  Created by Andrew on 15/11/5.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanViewController;

@interface AZAlertView : UIView

@property (nonatomic, weak) ScanViewController *ScanVC;

- (instancetype)initWithTY:(id)TYController andFrame:(CGRect)frame;
- (void)AZSetBarcodeResultWithTitle: (NSString *)title andImageURL: (NSURL *)imageURl;

@end
