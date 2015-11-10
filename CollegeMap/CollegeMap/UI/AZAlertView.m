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
#import "UIImage+ImageScale.h"
#import "BarcodeItemStore.h"
#import "HomePageTableViewDataSource.h"

@interface AZAlertView () <UITextFieldDelegate>
{
    NSString    * _title;
    NSURL       * _imageURL;
    NSString    * _valueInRMB;
    NSString    * _barcode;
    BOOL        _isPreView;
    BarcodeItem * _preViewItem;
}


@property (weak, nonatomic) IBOutlet UITextField                 *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView                 *imageView;
@property (weak, nonatomic) IBOutlet UILabel                     *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel                     *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton                    *saveButton;
@property (weak, nonatomic) IBOutlet UIButton                    *cancelButton;
@property (weak, nonatomic) IBOutlet UISwitch                    *switchButton;
@property (nonatomic, weak) HomePageTableViewDataSource          *tableViewDataSource;

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

- (void)AZSetBarcodeResultWithDic: (NSDictionary *)dic andBarcode: (NSString *)barcode
{
    _title = [dic objectForKey:ZAZResultTitle];
    _imageURL = [dic objectForKey:ZAZResultImage];
    _valueInRMB = [dic objectForKey:ZAZResultValue];
    _barcode = barcode;
    _isPreView = NO;
    
    self.nameTextField.text = _title;
    self.nameTextField.delegate = self;
    self.valueLabel.text = _valueInRMB;
    [self.imageView sd_setImageWithURL:_imageURL
                      placeholderImage:[UIImage imageNamed:@"15"]
                             completed:^(UIImage *image, NSError *error,
                                         SDImageCacheType cacheType, NSURL *imageURL){
                                 if (error) {
                                     NSLog(@"ERROR: %@",error);
                                 } else {
                                     NSLog(@"Image download success");
                                     NSLog(@"Image scale to size");
                                     
                                     UIImage *image = [self.imageView.image scaleToSize:self.imageView.frame.size];
                                     self.imageView.image = image;
                                 }
                             }];
    
    NSArray *views = @[self, self.saveButton, self.cancelButton];
    [self setupLayers: views];
}

- (void)setupLayers: (NSArray *)views
{
    for (UIView *aView in views) {
        aView.layer.cornerRadius  = 6;
        aView.layer.masksToBounds = YES;
    }
}


- (void)showPopUpPreView: (BarcodeItem *)item dataSource:(id)dataSource
{
    _isPreView   = YES;
    _preViewItem = item;
    self.tableViewDataSource = (HomePageTableViewDataSource *)dataSource;
    
    self.nameTextField.text     = item.itemName;
    self.nameTextField.delegate = self;
    self.valueLabel.text        = item.valueInRMB;
    self.imageView.image        = [item.itemImage scaleToSize:self.imageView.frame.size];
    self.switchButton.on        = item.isLiked;
    self.likeLabel.text         = item.isLiked ? @"YES" : @"NO";
    
    NSArray *views = @[self, self.saveButton, self.cancelButton];
    [self setupLayers: views];
}

#pragma mark - Button Action

- (IBAction)SaveTheBarcode:(id)sender {
    if (_isPreView) {
        _preViewItem.itemName = self.nameTextField.text;
        _preViewItem.isLiked  = self.switchButton.isOn ? YES : NO;
        
        [self.tableViewDataSource refreshData];
        [self hideView];
        return;
    }
    BarcodeItem *item = [[BarcodeItemStore sharedInstance] creatItem];
    item.itemName     = self.nameTextField.text;
    item.itemImage    = self.imageView.image;
    item.valueInRMB   = _valueInRMB;
    item.barcode      = _barcode;
    item.isLiked      = self.switchButton.isOn ? YES : NO;
    
    [self hideView];
    [self.ScanVC startCodeReading];
}

- (IBAction)cancelThis:(id)sender {
    [self hideView];
    
    if (_isPreView) {
        return;
    }
    
    [self.ScanVC startCodeReading];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)switchAction:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    
    self.likeLabel.text = theSwitch.isOn ? @"Like":@"NO";
}



@end
