//
//  QRCodeView.h
//  Tecom
//
//  Created by Andrew on 15/10/22.
//  Copyright (c) 2015年 NTIL. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UIColor (ext)

@interface UIColor (ext)

+ (UIColor *)TCQRScanColer;

+ (UIColor *)TCQRScanColerAlpha:(CGFloat)alpha;

@end

@interface QRCodeView : UIView

+ (id)defaultView;

- (void)showFailSoon;

@end
