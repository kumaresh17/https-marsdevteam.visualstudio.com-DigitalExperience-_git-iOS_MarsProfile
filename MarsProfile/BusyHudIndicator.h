//
//  BusyHudIndicator.h
//  MTD2016
//
//  Created by Kumaresh Shrivastava on 23/02/16.
//  Copyright © 2016 TechM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellHudView.h"


#define IS_IPHONE_5 ([[UIScreen mainScreen ] bounds].size.height == 568.0)
#define IS_IPHONE_5_Landscape ([[UIScreen mainScreen ] bounds].size.height == 320.0)
#define IS_IPHONE_6_Landscape ([[UIScreen mainScreen ] bounds].size.height == 375.0)
#define IS_IPHONE_6P_Landscape ([[UIScreen mainScreen ] bounds].size.height == 414.0)

#define IS_IPHONE_6 ([[UIScreen mainScreen ] bounds].size.height == 667.0)
#define IS_IPHONE_6P ([[UIScreen mainScreen ] bounds].size.height == 736.0)


@interface BusyHudIndicator : UIView
{
    UIView *roundedRectView;
    UIActivityIndicatorView *activityIndicator;
    CGRect mainBounds;
}

+ (BusyHudIndicator *)sharedInstance;

- (void)initIndicator;
- (void)startIndicator;
- (void)stopIndicator;

@end
