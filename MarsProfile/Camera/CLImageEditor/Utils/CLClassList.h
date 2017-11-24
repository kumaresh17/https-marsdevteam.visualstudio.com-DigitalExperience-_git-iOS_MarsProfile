//
//  CLClassList.h
//
//  Created by TechM on 2017/5/14.
//  Copyright (c) Mars Inc. All rights reserved.
//  reference: http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html
//

#import <Foundation/Foundation.h>

@interface CLClassList : NSObject

+ (NSArray*)subclassesOfClass:(Class)parentClass;

@end
