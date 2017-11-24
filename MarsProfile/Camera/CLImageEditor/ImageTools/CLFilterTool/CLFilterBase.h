//
//  CLFilterBase.h
//
//  Created by TechM on 2017/5/18.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../ToolSettings/CLImageToolSettings.h"

@protocol CLFilterBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface CLFilterBase : NSObject<CLImageToolProtocol, CLFilterBaseProtocol>

@end
