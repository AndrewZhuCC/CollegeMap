//
//  BarcodeItemStore.h
//  CollegeMap
//
//  Created by Andrew on 15/11/6.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BarcodeItem;

@interface BarcodeItemStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (BarcodeItemStore *)sharedInstance;
- (BarcodeItem *)creatItem;
- (NSArray *)allItem;

@end
