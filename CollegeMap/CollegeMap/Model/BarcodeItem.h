//
//  BarcodeItem.h
//  CollegeMap
//
//  Created by Andrew on 15/11/9.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface BarcodeItem : NSManagedObject

@property (nonatomic, retain) NSString * barcode;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) UIImage * itemImage;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic)         BOOL isLiked;

@end
