//
//  CLImageToolInfo+Private.h
//
//  Created by TechM on 2017/5/07.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import "../../CLImageToolInfo.h"

@protocol CLImageToolProtocol;

@interface CLImageToolInfo (Private)

+ (CLImageToolInfo*)toolInfoForToolClass:(Class<CLImageToolProtocol>)toolClass;
+ (NSArray*)toolsWithToolClass:(Class<CLImageToolProtocol>)toolClass;

@end
