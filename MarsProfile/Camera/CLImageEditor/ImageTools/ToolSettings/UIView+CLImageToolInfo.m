//
//  UIView+CLImageToolInfo.m
//
//  Created by TechM on 2017/5/18.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import "UIView+CLImageToolInfo.h"

#import <objc/runtime.h>

@implementation UIView (CLImageToolInfo)

- (CLImageToolInfo*)toolInfo
{
    return objc_getAssociatedObject(self, @"UIView+CLImageToolInfo_toolInfo");
}

- (void)setToolInfo:(CLImageToolInfo *)toolInfo
{
    objc_setAssociatedObject(self, @"UIView+CLImageToolInfo_toolInfo", toolInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)userInfo
{
    return objc_getAssociatedObject(self, @"UIView+CLImageToolInfo_userInfo");
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, @"UIView+CLImageToolInfo_userInfo", userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
