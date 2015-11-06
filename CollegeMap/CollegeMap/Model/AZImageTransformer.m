//
//  AZImageTransformer.m
//  CollegeMap
//
//  Created by Andrew on 15/11/6.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "AZImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation AZImageTransformer

+ (Class)transformedValueClass{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
