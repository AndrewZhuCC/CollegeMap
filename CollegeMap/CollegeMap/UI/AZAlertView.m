//
//  AZAlertViewController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/5.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZAlertView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ScanViewController.h"
#import "UIView+TYAlertView.h"

@interface AZAlertView ()
{
    NSString * _title;
    NSURL    * _imageURL;
}


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;


@end

@implementation AZAlertView

#pragma mark - Life Cycle

#pragma mark - Setup API

- (instancetype)initWithTY:(id)TYController andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AZAlertView" owner:TYController options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)AZSetBarcodeResultWithTitle: (NSString *)title andImageURL: (NSURL *)imageURl
{
    _title = title;
    _imageURL = imageURl;
    
    self.nameTextField.text = _title;
    [self.imageView sd_setImageWithURL:_imageURL
                      placeholderImage:[UIImage imageNamed:@"15"]
                             completed:^(UIImage *image, NSError *error,
                                         SDImageCacheType cacheType, NSURL *imageURL){
                                 if (error) {
                                     NSLog(@"ERROR: %@",error);
                                 } else {
                                     NSLog(@"Image download success");
                                 }
                             }];
}

#pragma mark - Button Action

- (IBAction)SaveTheBarcode:(id)sender {
    [self hideView];
    [self.ScanVC startCodeReading];
}

- (IBAction)cancelThis:(id)sender {
    [self hideView];
    [self.ScanVC startCodeReading];
}

- (IBAction)switchAction:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    
    self.likeLabel.text = theSwitch.isOn ? @"Like":@"NO";
}

@end
