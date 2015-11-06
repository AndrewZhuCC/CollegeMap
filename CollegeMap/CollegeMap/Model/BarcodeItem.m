//
//  BarcodeItem.m
//  CollegeMap
//
//  Created by Andrew on 15/11/6.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "BarcodeItem.h"


@implementation BarcodeItem

@dynamic itemName;
@dynamic barcode;
@dynamic itemImage;
@dynamic dateCreated;

/**
 *  当新对象增加到数据库的时候会调用下面的方法
 */
- (void)awakeFromFetch
{
    [super awakeFromFetch];
    self.dateCreated = [NSDate date];
}

@end
