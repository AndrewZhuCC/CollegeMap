//
//  NetWorkController.h
//  CollegeMap
//
//  Created by Andrew on 15/11/4.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ZAZResultTitle = @"zazResultTitle";
static NSString *const ZAZResultImage = @"zazResultImage";

@interface NetWorkController : NSObject

- (NSDictionary *)searchBarcode:(NSString *)barcode;

@end