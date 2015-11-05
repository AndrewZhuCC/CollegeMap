//
//  AZAlertController.h
//  CollegeMap
//
//  Created by Andrew on 15/11/5.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZAlertController : NSObject

- (instancetype)initWithTitle: (NSString *)title andImageURL: (NSURL *)imageURL;
- (void)showAlertView;

@end
