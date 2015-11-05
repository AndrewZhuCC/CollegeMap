//
//  AZAlertViewController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/5.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZAlertViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AZAlertViewController ()
{
    NSString * _title;
    NSURL    * _imageURL;
}
@end

@implementation AZAlertViewController

- (void)AZSetFrame:(CGRect)frame
{
    [self.view setFrame:frame];
}

- (void)AZSetBarcodeResultWithTitle: (NSString *)title andImageURL: (NSURL *)imageURl
{
    _title = title;
    _imageURL = imageURl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = _title;
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
