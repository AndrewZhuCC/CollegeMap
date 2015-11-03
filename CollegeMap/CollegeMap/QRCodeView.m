//
//  QRCodeView.m
//  Tecom
//
//  Created by Andrew on 15/10/22.
//  Copyright (c) 2015年 NTIL. All rights reserved.
//

#import "QRCodeView.h"

#pragma mark - UIColor (ext)

@implementation UIColor (ext)

+ (UIColor *)TCQRScanColer
{
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.35]; //e6ffac
    //    return [UIColor colorWithRed:0.043 green:0.322 blue:0.102 alpha:0.5];
}

+ (UIColor *)TCQRScanColerAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:alpha]; //e6ffac
}

@end

#pragma mark - QRCodeView

@implementation QRCodeView

+ (id)defaultView
{
        return [[QRCodeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = self.center;
    CGFloat w = width * 0.75;
    CGFloat h = w * 0.5;
    center.y += 20;
    CGRect rScan = CGRectMake(center.x-(w/2), center.y-(h/2), w, h);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor TCQRScanColer].CGColor);//[UIColor colorWithWhite:0.2 alpha:0.5].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    
    //CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rScan), /*midx = CGRectGetMidX(rScan),*/ maxx = CGRectGetMaxX(rScan);
    CGFloat miny = CGRectGetMinY(rScan), midy = CGRectGetMidY(rScan), maxy = CGRectGetMaxY(rScan);
    
    // 外框
    CGContextMoveToPoint(context, 0, -44);              // *
    CGContextAddLineToPoint(context, -44, midy);        // ↓    * ←←←←←←←←←←←
    CGContextAddLineToPoint(context, minx, midy);       // →    ↓           ↑
    CGContextAddLineToPoint(context, minx, miny);       // ↑    ↓           ↑
    CGContextAddLineToPoint(context, maxx, miny);       // →    ↓  →→→→→→→  ↑
    CGContextAddLineToPoint(context, maxx, maxy);       // ↓    ↓ ↑       ↓ ↑
    CGContextAddLineToPoint(context, minx, maxy);       // ←    →-←       ↓ ↑
    CGContextAddLineToPoint(context, minx, midy);       // ↑    ↓ ↑       ↓ ↑
    CGContextAddLineToPoint(context, 0, midy);          // ←    ↓  ←←←←←←←  ↑
    CGContextAddLineToPoint(context, 0, height);        // ↓    ↓           ↑
    CGContextAddLineToPoint(context, width, height);    // →    ↓           ↑
    CGContextAddLineToPoint(context, width, -44);       // ↑    →→→→→→→→→→→→→
    CGContextAddLineToPoint(context, 0, -44);           // ←
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (self.tag == 0) {
        UIImage *image = [UIImage imageNamed:@"codeReaderLine"];
        [image drawInRect:rScan];
    }
    else {
        UIImage *image = [UIImage imageNamed:@"codeReaderLine_error"];
        [image drawInRect:rScan];
    }
    
}

- (void)showFailSoon
{
    self.tag = -1;
    [self setNeedsDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2.0), dispatch_get_main_queue(), ^(void){
        self.tag = 0;
        [self setNeedsDisplay];
    });
}



@end
