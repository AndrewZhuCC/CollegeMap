//
//  AZAlertController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/5.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZAlertController.h"
#import "AZAlertViewController.h"
#import "KLCPopup.h"

@interface AZAlertController ()
{
    NSString * _title;
    NSURL    * _imageURL;
}

@property (nonatomic, weak) KLCPopup *popUp;

@end

@implementation AZAlertController

- (instancetype)initWithTitle: (NSString *)title andImageURL: (NSURL *)imageURL
{
    if (self = [super init]) {
        _title = title;
        _imageURL = imageURL;
    }
    return self;
}

- (void)showAlertView
{
    [self configFormSheetView];
    
    [_popUp show];
    NSLog(@"popup show");
}

- (void)configFormSheetView
{
    AZAlertViewController *azViewController = [[AZAlertViewController alloc]init];
    [azViewController AZSetFrame:CGRectMake(10, 10, 250, 250)];
    KLCPopup *temppopUp =
    [KLCPopup popupWithContentView:azViewController.view
                          showType:KLCPopupShowTypeFadeIn
                       dismissType:KLCPopupDismissTypeFadeOut
                          maskType:KLCPopupMaskTypeDimmed
          dismissOnBackgroundTouch:YES
             dismissOnContentTouch:NO];
    
    _popUp = temppopUp;
}

@end
