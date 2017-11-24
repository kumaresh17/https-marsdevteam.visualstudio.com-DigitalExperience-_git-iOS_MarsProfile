//
//  CLSplineInterpolator.h
//
//  Created by TechM on 2017/5/18.
//  Copyright (c) Mars Inc. All rights reserved.
//  Reference: http://www5d.biglobe.ne.jp/%257estssk/maze/spline.html
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLSplineInterpolator : NSObject

- (id)initWithPoints:(NSArray*)points;          // points: array of CIVector
- (CIVector*)interpolatedPoint:(CGFloat)t;      // {t | 0 ≤ t ≤ 1}

@end
