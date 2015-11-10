//
//  BarcodeItem.m
//  CollegeMap
//
//  Created by Andrew on 15/11/9.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "BarcodeItem.h"


@implementation BarcodeItem

@dynamic barcode;
@dynamic dateCreated;
@dynamic itemImage;
@dynamic itemName;
@dynamic isLiked;
@dynamic valueInRMB;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.dateCreated = [NSDate date];
}

@end
