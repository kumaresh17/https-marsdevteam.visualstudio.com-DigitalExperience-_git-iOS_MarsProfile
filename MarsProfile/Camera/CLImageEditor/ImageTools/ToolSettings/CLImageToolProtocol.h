//
//  CLImageToolProtocol.h
//
//  Created by TechM on 2017/5/18.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLImageToolProtocol

@required
+ (NSString*)defaultIconImagePath;
+ (CGFloat)defaultDockedNumber;
+ (NSString*)defaultTitle;
+ (BOOL)isAvailable;
+ (NSArray*)subtools;
+ (NSDictionary*)optionalInfo;

@end
