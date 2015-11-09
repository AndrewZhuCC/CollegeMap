//
//  UIImage+ImageScale.h
//  CollegeMap
//
//  Created by Andrew on 15/11/9.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (UIImage_ImageScale)

-(UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)changeSizeToSize: (CGSize)size;

@end
