//
//  UIDevice+SystemVersion.m
//
//  Created by TechM on 2017/5/06.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

+ (CGFloat)iosVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
